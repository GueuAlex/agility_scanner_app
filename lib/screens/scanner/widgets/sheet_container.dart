import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/qr_code_model.dart';
import '../../../model/scan_history_model.dart';
import '../../../model/user.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/custom_button.dart';
import 'infos_column.dart';
import 'sheet_header.dart';

class SheetContainer extends StatefulWidget {
  ///:::::::::::///////////////////:
  /// a utiliser pour l'api
  /// on va utilise qrValue, pour une requet get dans notre api
  /// pour obtenir toutes les infos du rqcode qu'on vient de scanné
  final String qrValue;
  ////////:::::::::::::////////////////
  const SheetContainer({
    super.key,
    required this.qrValue,
  });

  @override
  State<SheetContainer> createState() => _SheetContainerState();
}

class _SheetContainerState extends State<SheetContainer> {
  bool showLabel1 = true;
  bool showLabel2 = true;

  ////////////////
  ///nous permet d'afficher un gift de chargement
  ///mais je ne suis pas sûr de cette de methode
  ///a changer plutard
  bool isLoading = true;

  ///////////////////
  final TextEditingController iDController = TextEditingController();
  final TextEditingController cariDController = TextEditingController();
  final TextEditingController cariDController2 = TextEditingController();
  /////////////////////
  ///
  String alertCarIDValue = '';

  User? user;
  QrCodeModel? _qrCodeModel;

  @override
  void initState() {
    //getUser(id: int.parse(widget.qrValue));
    getQrCode(qrCodeId: int.parse(widget.qrValue));
    /////////
    Future.delayed(const Duration(seconds: 4)).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  ////////////////////////////////////
  ///fonction qui nous permet de faire la requette get
  ///sur notre api
  getQrCode({required int qrCodeId}) async {
    ////////////////////
    /// eventualité de faire appel a api/qrcodes/id
    /// si les données devient trop lourde a chargé
    ///
    QrCodeModel qrCodeModel = await QrCodeModel.qrCodeList.firstWhere(
      (element) => element.id == qrCodeId,
    );
    _qrCodeModel = qrCodeModel;
    user = _qrCodeModel!.user;
    //print(_qrCodeModel);
  }

  @override
  Widget build(BuildContext context) {
    /////////////////
    ///text fields
    final Widget idTextField = TextField(
      controller: iDController,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onTap: () {
        setState(() {
          showLabel1 = false;
        });
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        label:
            showLabel1 ? AppText.medium('Entrez un n° de pièce') : Container(),
        border: InputBorder.none,
      ),
    );
    ////////////////////////
    ///
    ///
    final Widget cardIddTextField = TextField(
      controller: cariDController,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onTap: () {
        setState(() {
          showLabel2 = false;
        });
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        label: showLabel2
            ? AppText.medium(
                'Entrez un n° d\'immatriculation de véhicule',
              )
            : Container(),
        border: InputBorder.none,
      ),
    );

    // utilise dans code
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.only(top: size.height - (size.height / 1.3)),
        height: size.height / 1.3,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            const AllSheetHeader(),
            Expanded(
              child: !isLoading
                  ? SingleChildScrollView(
                      child: user != null
                          ? Column(
                              children: [
                                SheetHeader(
                                  user: user!,
                                  qrCodeModel: _qrCodeModel!,
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: getWidget(
                                      qrCodeModel: _qrCodeModel!,
                                      idTextField: idTextField,
                                      cardIddTextField: cardIddTextField,
                                    )),
                              ],
                            )
                          : Functions.widget404(size: size, ctxt: context),
                    )
                  : Center(
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        child: Center(
                          child: Image.asset('assets/images/loading.gif'),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  ///
  ///////////////////////////////////////////////////////////////////

// widget retourné si un qr code a deja été scané
  Widget isAlreadyScanWidget({
    required User user,
    required QrCodeModel qrCodeModel,
  }) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: InfosColumn(
                label: 'Date',
                widget: Expanded(
                  child: AppText.medium(
                    DateFormat(
                      'EE dd MMM yyyy',
                      'fr_FR',
                    ).format(
                      DateTime.now(),
                    ),
                    textOverflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InfosColumn(
                label: 'Heure',
                widget: AppText.medium(
                  DateFormat('HH:mm').format(
                    DateTime.now(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          color: Color.fromARGB(255, 57, 143, 77),
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Entrée ?',
          onPress: () {
            /////////////// on cree une instance de scanHistoryModel  //////////
            /// de motif: "Entrée"///
            ///
            String hours = DateFormat('HH:mm', 'fr_FR').format(
              DateTime.now(),
            );

            ScanHistoryModel scanHistoryModel = ScanHistoryModel(
              id: 1,
              qrCodeId: qrCodeModel.id,
              scandDate: Functions.getToday(),
              scanHour: hours,
              motif: 'Entrée',
            );
            setState(() {
              cariDController2.text = user.plaqueVehicule;
            });
            /////////////////////////////////////////////////
            /// on affiche une alerte modale pour la
            /// confirmation
            Functions.IsAllRedyScanalert(
              carIdField: getTextfiel(
                controller: cariDController2,
                //hintext: user.plaqueVehicule,
              ),
              ctxt: context,
              user: user,
              confirm: () => upDateScanHistory(
                carID: cariDController2.text,
                scanHistoryModel: scanHistoryModel,
              ),
              cancel: () => Navigator.pop(
                  context), // sinon Navigator.pop(context) si c'est annuler
            );
            /* _showDialog(ctxt: context, textField: [
              DialogTextField(
                validator: (value) {
                  if (value != null) {
                    print(value);
                    alertCarIDValue = value;
                  }
                  print('------- $alertCarIDValue');
                  return;
                },
              )
            ]); */
          },
        ),
        const SizedBox(
          height: 10,
        ),
        CustomButton(
          color: Palette.secondaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Sortie ?',
          onPress: () {
            /////////////// on cree une instance de scanHistoryModel  //////////
            /// de motif: "Sortie"///
            ///
            String hours = DateFormat('HH:mm', 'fr_FR').format(
              DateTime.now(),
            );

            ScanHistoryModel scanHistoryModel = ScanHistoryModel(
              id: 309,
              qrCodeId: qrCodeModel.id,
              scandDate: Functions.getToday(),
              scanHour: hours,
              motif: 'Sortie',
            );
            setState(() {
              cariDController2.text = '';
            });
            /////////////////////////////////////////////////
            /// on affiche une alerte modale pour la
            /// confirmation
            Functions.IsAllRedyScanalert(
              carIdField: getTextfiel(
                controller: cariDController2,
                // hintext: user.plaqueVehicule,
              ),
              ctxt: context,
              isEntree: false,
              user: user,
              confirm: () => upDateScanHistory(
                // on appel upDateScanHistory() si c'est confirmé
                carID: cariDController2.text,
                scanHistoryModel: scanHistoryModel,
                isEntree: false,
              ),
              cancel: () => Navigator.pop(
                  context), // sinon Navigator.pop(context) si c'est annuler
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        /*   CustomButton(
          color: Palette.primaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Sortie définitive ?',
          onPress: () {
            /////////////// on cree une instance de scanHistoryModel  //////////
            /// de motif: "Sortie"///
            ///
            String hours = DateFormat('HH:mm', 'fr_FR').format(
              DateTime.now(),
            );

            ScanHistoryModel scanHistoryModel = ScanHistoryModel(
              id: 309,
              qrCodeId: qrCodeModel.id,
              scandDate: Functions.getToday(),
              scanHour: hours,
              motif: 'Sortie',
            );
            /////////////////////////////////////////////////
            /// on affiche une alerte modale pour la
            /// confirmation
            alert1(
              ctxt: context,
              //isEntree: false,
              user: user,
              confirm: () => upDateScanHistoryAndDesableQrCode(
                // on appel upDateScanHistory() si c'est confirmé
                scanHistoryModel: scanHistoryModel,
                qrCodeModel: qrCodeModel,
              ),
              cancel: () => Navigator.pop(
                  context), // sinon Navigator.pop(context) si c'est annuler
            );
          },
        ), */
      ],
    );
  }

  //Alert de sortie définitive
  Future<Null> alert1({
    required BuildContext ctxt,
    required Function() confirm,
    required Function() cancel,
    required User user,
  }) async {
    return showDialog(
        barrierDismissible: false,
        context: ctxt,
        builder: (BuildContext ctxt) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: AppText.medium('Confirmation'),
            content: AppText.small(
              'Attention, cette action entraînera la désactivation du QR code et du code associé.',
              textAlign: TextAlign.left,
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
        });
  }

//affiche un alerte dialogue de confirmation en cas de modification
  Future<Null> alert({
    required BuildContext ctxt,
    bool isEntree = true,
    required Function() confirm,
    required Function() cancel,
    required User user,
    //required TextField carIdField,
  }) async {
    return showDialog(
      barrierDismissible: false,
      context: ctxt,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: AppText.medium('Confirmation'),
          content: AppText.small(
            isEntree
                ? 'Enregistrer une entrée pour ${user.nom} ${user.prenoms} ?'
                : 'Enregistrer une sortie pour ${user.nom} ${user.prenoms} ?',
            textAlign: TextAlign.left,
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

/* l'alert dialog afficher lorsque qr code à déjà été scanné */
////////////////

//met a jour l'historique des scans de l'api
  Future<void> upDateScanHistory({
    required String carID,
    bool isEntree = true,
    required ScanHistoryModel scanHistoryModel,
  }) async {
    Functions.showLoadingSheet(ctxt: context);
    ///////////////////////////////////
    /// update via APIs here
    scanHistoryModel.carId = carID;
    Functions.postScanHistory(scanHistoryModel: scanHistoryModel);

    /// //////////////////////////////////
    /// if update via APIs is done
    ScanHistoryModel.scanHistories.add(scanHistoryModel);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Functions.showSnackBar(
        ctxt: context,
        messeage: isEntree ? 'Entrée enregistrée !' : 'Sortie enregistrée !',
      );
    });
  }

  //met a jour l'historique des scans de l'api
  Future<void> upDateScanHistoryAndDesableQrCode({
    required ScanHistoryModel scanHistoryModel,
    required QrCodeModel qrCodeModel,
  }) async {
    //////////////// to desable qrcode from db //////////:
    var data = {"is_active": 0};
    /////////////////////////////////////////////////////
    ///////////////////////////////////
    /// update via APIs here
    Functions.postScanHistory(scanHistoryModel: scanHistoryModel);
    Functions.updateQrcode(data: data, qrCodeId: scanHistoryModel.qrCodeId);

    /// //////////////////////////////////
    /// if update via APIs is done
    qrCodeModel.isActive = false;
    ScanHistoryModel.scanHistories.add(scanHistoryModel);
    Navigator.pop(context);
    Functions.showSnackBar(
      ctxt: context,
      messeage: 'Sortie enregistrée et qr code desactivé !',
    );
  }

// widget retourné si un qr code est scané pour la premiere fois
  Widget fisrtScanWidget({
    required Widget idTextField,
    required Widget cardIddTextField,
    required User user,
    required QrCodeModel qrCodeModel,
  }) {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    String hours = DateFormat('HH:mm').format(DateTime.now());
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfosColumn(
                label: 'Date début',
                widget: AppText.medium(
                  DateFormat(
                    'dd MMM yyyy',
                    'fr_FR',
                  ).format(
                    qrCodeModel.dateDebut,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InfosColumn(
                label: 'Heure d\'entrée',
                widget: AppText.medium(
                  DateFormat('HH:mm').format(DateTime.now()),
                ),
              ),
            ),
          ],
        ),
        InfosColumn(
          opacity: 0.3,
          label: 'n° de pièce',
          widget: Expanded(
            child: idTextField,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        InfosColumn(
          opacity: 0.3,
          label: 'n° d\'immatriculation véhicule',
          widget: Expanded(
            child: cardIddTextField,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        CustomButton(
          color: Palette.primaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Sauvegarder le scan',
          //////////////////////////////////////////////////
          ///on a besoin update le n° CNI et le n° d'immatricule du user
          ///anisi l'attribut iSAlreadyScanned du qr code qu'on vient de scanné
          onPress: () {
            int iid = Random().nextInt(99999);
            ////////////////////////////////////////////////////////////
            //préparation des données pour update les tables qr_code et visiteur
            ///
            Map<String, dynamic> qrcodeData = {
              "is_already_scanned": 1,
            };
            /////////////////////////
            ///
            Map<String, dynamic> userData = {
              "numero_cni": iDController.text,
              "plaque_vehicule": cariDController.text,
            };

            ScanHistoryModel scanHistoryModel = new ScanHistoryModel(
              id: iid,
              qrCodeId: qrCodeModel.id,
              scandDate: today,
              scanHour: hours,
              motif: 'Entrée',
            );

            alert(
                ctxt: context,
                confirm: () {
                  Functions.showLoadingSheet(ctxt: context);
                  Functions.updateQrcode(
                    data: qrcodeData,
                    qrCodeId: qrCodeModel.id,
                  );
                  //updateQrcode(data: data, qrCodeId: qrCodeId)
                  Functions.updateUser(data: userData, userId: user.id);
                  Functions.postScanHistory(scanHistoryModel: scanHistoryModel);

                  //////////////////////
                  ///pour le test
                  ///mise des infos du user et du qr code
                  qrCodeModel.isAlreadyScanned = true;
                  user.numeroCni = iDController.text;
                  user.plaqueVehicule = cariDController.text;

                  ScanHistoryModel.scanHistories.add(scanHistoryModel);
                  //////////////////////////////////fin test ////////////////
                  ///
                  Future.delayed(const Duration(seconds: 3)).then(
                    (_) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Functions.showSnackBar(
                        ctxt: context,
                        messeage: 'Scan sauvegardé !',
                      );
                    },
                  );
                },
                cancel: () => Navigator.pop(context),
                user: user);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        CustomButton(
          color: Palette.secondaryColor,
          width: double.infinity,
          height: 35,
          radius: 5,
          text: 'Annuler',
          onPress: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

//widget retourné si la date de visite n'est pas encore atteinte
  Widget dateException({required DateTime dateDebut}) {
    return Container(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Center(
        child: Column(
          children: [
            AppText.medium('Date de visite !'),
            const SizedBox(
              height: 5,
            ),
            AppText.small(
              'La date de visite pour ce code est prévue pour le\n${DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(dateDebut)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              color: Palette.primaryColor,
              width: double.infinity,
              height: 35,
              radius: 5,
              text: 'Retour',
              onPress: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  //widget retourné si la date de visite n'est pas encore atteinte
  Widget dateExpiree({required DateTime dateFin}) {
    return Container(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Center(
        child: Column(
          children: [
            AppText.medium('Qr code expiré !'),
            const SizedBox(
              height: 5,
            ),
            AppText.small(
              'Ce code a expiré depuis le\n${DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(dateFin)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              color: Palette.primaryColor,
              width: double.infinity,
              height: 35,
              radius: 5,
              text: 'Retour',
              onPress: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

// widget retourné si le qr code inactif
  Widget inactifQrCode() {
    return Container(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/disconnect.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppText.medium('Oops !'),
          AppText.small('Votre Qr code est désactivé !'),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            color: Palette.primaryColor,
            width: double.infinity,
            height: 35,
            radius: 5,
            text: 'Retour',
            onPress: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////////////
  ///fonction permettant de return un widget spécifique
  /// a l'etat du qrCode
  /// selon :
  ///   1. si la date de visite n'est encore arriver
  ///   2. si le qr code est actif
  ///       2.1. s'il est actif et s'il n'a pas déjà été scanné
  ///       2.2. s'il est actif et a déjà été scanné
  ///   3. si la date de visite est passée
  ///   4. si le qr code n'est pas actif
  ///
  ///
  Widget getWidget({
    required QrCodeModel qrCodeModel,
    required Widget idTextField,
    required Widget cardIddTextField,
  }) {
    ////////////// formatage de la date début et la date d'experemption du qr
    DateTime dateDebut = DateTime(
      qrCodeModel.dateDebut.year,
      qrCodeModel.dateDebut.month,
      qrCodeModel.dateDebut.day,
    );

    ////////////////////////////////////////
    /// 3. si la date vite est passée
    if (qrCodeModel.dateFin != null) {
      DateTime dateFin = DateTime(
        qrCodeModel.dateFin!.year,
        qrCodeModel.dateFin!.month,
        qrCodeModel.dateFin!.day,
      );
      if (dateFin.isBefore(Functions.getToday())) {
        return dateExpiree(dateFin: dateFin);
      }
    }

    ////////////////////////////////////////////////////
    ///   1. la date de visite n'est pas encre arrivé
    if (dateDebut.isAfter(Functions.getToday())) {
      return dateException(dateDebut: dateDebut);
    }

    ///////////////////////////////////////////////////
    ///   2. si le code actif
    if (qrCodeModel.isActive) {
      //////////////////////////////////////////////////////
      ///   2.1 s'il est actif et s'il n'a pas déjà été scanné
      ///       alors on return fisrtScanWidget()
      if (!qrCodeModel.isAlreadyScanned) {
        return fisrtScanWidget(
          idTextField: idTextField,
          cardIddTextField: cardIddTextField,
          user: qrCodeModel.user,
          qrCodeModel: qrCodeModel,
        );
      }
      //////////////////////////////////////////////////
      ///   2.2. s'il est actif et a déjà été scanné
      ///       alors on return isAlreadyScanWidget()
      if (qrCodeModel.isAlreadyScanned) {
        return isAlreadyScanWidget(
            qrCodeModel: qrCodeModel, user: qrCodeModel.user);
      }
    }

    ////////////////////////////////////////
    /// 4. si le qr code n'est pas actif
    return inactifQrCode();
  }

  /////////////////::
  ///
  ///
  TextField getTextfiel({
    required TextEditingController controller,
    //required String hintext,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        //label: AppText.medium(hintext),
        border: InputBorder.none,
      ),
    );
  }
}
