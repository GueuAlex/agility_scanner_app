import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner/model/entreprise_model.dart';
import 'package:scanner/model/livraison_model.dart';

import '../model/qr_code_model.dart';
import '../model/scan_history_model.dart';
import '../model/user.dart';
import '../remote_service/remote_service.dart';
import '../widgets/custom_button.dart';
import 'app_text.dart';
import 'palette.dart';

class Functions {
  static void showSnackBar(
      {required BuildContext ctxt, required String messeage}) {
    ScaffoldMessenger.of(ctxt).showSnackBar(
      SnackBar(
        content: AppText.medium(
          messeage,
          color: Colors.white70,
        ),
        duration: const Duration(seconds: 3),
        elevation: 5,
      ),
    );
  }

  /// bottom sheet preconfiguré
  static Future<void> showBottomSheet({
    required BuildContext ctxt,
    required Widget widget,
  }) async {
    return await showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      context: ctxt,
      builder: (context) {
        return widget;
      },
    );
  }

// gift de chargement
  static showLoadingSheet({required BuildContext ctxt}) {
    return showDialog(
      context: ctxt,
      //backgroundColor: Colors.transparent,
      builder: (ctxt) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(ctxt).size.height,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Image.asset('assets/images/loading.gif'),
              ),
              const SizedBox(
                height: 230,
              )
            ],
          ),
        );
      },
    );
  }

  static DateTime getToday() {
    // renvoi la date du jour
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  /// renvoi un widget avec a l'intérieur un érreur 404
  static Widget widget404({required Size size, required BuildContext ctxt}) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      //height: size.height / 1.5,
      width: size.width,
      child: Center(
        child: Column(
          children: [
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset('assets/icons/404.svg'),
            ),
            //AppText.medium('Not found !'),
            AppText.small('Aucune correspondance !'),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              color: Palette.primaryColor,
              width: double.infinity,
              height: 35,
              radius: 5,
              text: 'Retour',
              onPress: () => Navigator.pop(ctxt),
            )
          ],
        ),
      ),
    );
  }

//retour une liste des qr code déjà scanné en se basant
// sur la lite des historique de scan
  static List<QrCodeModel> getScannedQrCode(
      {required List<ScanHistoryModel> scanList}) {
    Set<QrCodeModel> qrs = {};
    for (QrCodeModel qrCodes in QrCodeModel.qrCodeList) {
      for (ScanHistoryModel element in scanList) {
        if (qrCodes.id == element.qrCodeId) {
          qrs.add(qrCodes);
        }
      }
    }
    return qrs.toList();
  }

//retourn la liste des historique de scan
// en se basant sur selectedDate
  static List<ScanHistoryModel> getSelectedDateScanHistory({
    required DateTime selectedDate,
  }) {
    List<ScanHistoryModel> scanList = [];
    scanList.clear();
    for (ScanHistoryModel element in ScanHistoryModel.scanHistories) {
      // print(element.scandDate);
      if (element.scandDate == selectedDate) {
        scanList.add(element);
      }
    }
    return scanList;
  }

  static List<Livraison> getSelectedDateLivraisons({
    required DateTime selectedDate,
  }) {
    print('selectedDate : ${selectedDate}');
    List<Livraison> deliList = [];
    deliList.clear();
    for (Livraison element in Livraison.livraisonList) {
      print(element.dateVisite);
      if (element.dateLivraison == selectedDate && element.statutLivraison) {
        deliList.add(element);
      }
    }
    return deliList;
  }

  // met a jour un qr code
  static Future<dynamic> updateQrcode({
    required Map<String, dynamic> data,
    required int qrCodeId,
  }) async {
    await RemoteService().putSomethings(
      api: 'qrcodes/${qrCodeId}',
      data: data,
    );
  }

  // met a jour un user
  static Future<dynamic> updateUser({
    required Map<String, dynamic> data,
    required int userId,
  }) async {
    RemoteService().putSomethings(
      api: 'visiteurs/${userId}',
      data: data,
    );
  }

// post un nouveau historique de scan
  static Future<dynamic> postScanHistory(
      {required ScanHistoryModel scanHistoryModel}) async {
    RemoteService().postScanHistory(scanHistoryModel: scanHistoryModel);
  }

// retourne la liste des qr code depuis l'api
  static getQrcodesFromApi() async {
    QrCodeModel.qrCodeList = await RemoteService().getQrcodes();
  }

// retourne l'historique des qr code depuis l'api
  static getScanHistoriesFromApi() async {
    ScanHistoryModel.scanHistories = await RemoteService().getScanHistories();
  }

  //retourne la liste de toutes les entreprise
  static allEntrepise() async {
    Entreprise.entrepriseList = await RemoteService().getEntrepriseList();
  }

  //retourne la liste de toutes les entreprise
  static allLivrason() async {
    Livraison.livraisonList = await RemoteService().getLivraisonList();
  }

  /////////////////////////////////
  ///
  ///
  static Future<Null> IsAllRedyScanalert({
    required BuildContext ctxt,
    bool isEntree = true,
    required Function() confirm,
    required Function() cancel,
    required User user,
    required TextField carIdField,
  }) async {
    return showDialog(
      barrierDismissible: false,
      context: ctxt,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: AppText.medium(
            'Confirmation',
            fontSize: 12,
          ),
          /* content: AppText.small(
            isEntree
                ? 'Enregistrer une entrée pour ${user.nom} ${user.prenoms} ?'
                : 'Enregistrer une sortie pour ${user.nom} ${user.prenoms} ?',
            textAlign: TextAlign.left,
          ), */
          content: ConstrainedBox(
            constraints: BoxConstraints.expand(height: isEntree ? 70 : 30),
            child: Column(
              children: [
                Expanded(
                  child: AppText.small(
                    isEntree
                        ? 'Saisire la plaque d\'immatriculation si ${user.nom} est véhiculé sinon laissez le champs vide'
                        : 'Veuillez confirmer la sortie de ${user.nom}',
                    textAlign: TextAlign.center,
                    fontSize: 10,
                  ),
                ),
                isEntree
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(top: 5),
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: carIdField,
                      )
                    : Container(),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 5.0,
            right: 15.0,
            left: 15.0,
          ),
          titlePadding: const EdgeInsets.only(
            top: 10,
            left: 15,
          ),
          actions: [
            TextButton(
              onPressed: confirm,
              child: AppText.small(
                'Confirmer',
                fontWeight: FontWeight.w500,
                color: Palette.primaryColor,
              ),
            ),
            TextButton(
              onPressed: cancel,
              child: AppText.small(
                'Annuler',
                fontWeight: FontWeight.w500,
                color: Palette.primaryColor,
              ),
            )
          ],
        );
      },
    );
  }

  static showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Palette.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Widget getTextField(
      {required TextEditingController controller, bool isActive = true}) {
    return TextField(
      enabled: isActive,
      controller: controller,
      keyboardType: TextInputType.text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
