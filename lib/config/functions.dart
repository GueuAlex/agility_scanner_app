import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../model/qr_code_model.dart';
import '../model/scan_history_model.dart';
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
  static showBottomSheet({
    required BuildContext ctxt,
    required Widget widget,
  }) {
    return showModalBottomSheet(
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
}
