import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scanner/model/qr_code_model.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/overlay.dart';
import '../../config/palette.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/action_button.dart';
import '../../widgets/all_sheet_header.dart';
import '../../widgets/copy_rigtht.dart';
import '../../widgets/custom_button.dart';
import '../side_bar/custom_side_bar.dart';
import '../side_bar/open_side_dar.dart';
import 'widgets/error_sheet_container.dart';
import 'widgets/sheet_container.dart';
import 'widgets/verify_by_code_sheet.dart';

class ScanSreen extends StatefulWidget {
  static String routeName = '/scannerScreen';
  const ScanSreen({super.key});

  @override
  State<ScanSreen> createState() => _ScanSreenState();
}

class _ScanSreenState extends State<ScanSreen> {
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFontCamera = false;

  bool isTextFieldVisible = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  MobileScannerController mobileScannerController = MobileScannerController();
  bool showLabel1 = true;
  final TextEditingController codeController = TextEditingController();

  //////////////////
  void closeScreen() {
    isScanCompleted = false;
  }

  ////////////////
  ///
  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const CustomSiderBar(),
      appBar: AppBar(
        leading: const OpenSideBar(),
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        elevation: 0,
        title: AppText.medium('QR Scanner'),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: AppText.medium(
            'Double clic pour quitter',
            color: Colors.grey,
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            //padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.medium('Placez le code QR dans la zone'),
                      AppText.small('La numérisation démarre automatiquement')
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: mobileScannerController,
                        allowDuplicates: true,
                        ////////////////
                        // onDetect: fonction lancée lorsqu'un rq code est
                        // detecté par la cam
                        ////////////////////
                        onDetect: (barcodes, args) async {
                          if (!isScanCompleted) {
                            ////////////////
                            /// code =  données que le qrcode continet
                            String code = barcodes.rawValue ?? '...';
                            // print('qr code value is : $code');
                            //////////////
                            //final codePattern = RegExp(r'^AG-\d{2}-\d+$');
                            final int? id = int.tryParse(code);

                            /// booleen permettant de connaitre l'etat
                            /// du process de scanning
                            isScanCompleted = true;
                            //////////////////////////
                            /// on attend un int
                            /// donc on int.tryParse code pour etre sur de
                            /// son type
                            // int? id = int.tryParse(code);

                            ///
                            /////////////////////////////
                            ///id represente l'id du qrcode dans notre DB
                            /// si id n'est pas null, on envoie id
                            /// a SheetContainer .....
                            if (id != null) {
                              EasyLoading.show();

                              await RemoteService()
                                  .getVisite(
                                visiteId: id.toString(),
                              )
                                  .then((response) async {
                                //EasyLoading.dismiss();
                                if (response.statusCode == 200 ||
                                    response.statusCode == 201) {
                                  //
                                  QrCodeModel visite = qrCodeModelFromJson(
                                    response.body,
                                  );

                                  // print(visite);

                                  await player
                                      .play(AssetSource('images/soung.mp3'));
                                  // player.play('images/soung.mp3');

                                  Functions.showBottomSheet(
                                    ctxt: context,
                                    widget: SheetContainer(
                                      visite: visite,
                                      //qrValue: "1",
                                    ),
                                  ).whenComplete(() {
                                    Future.delayed(const Duration(seconds: 3))
                                        .then((_) {
                                      setState(() {
                                        isScanCompleted = false;
                                      });
                                    });
                                  });
                                  ;
                                  EasyLoading.dismiss();
                                } else {
                                  //print('object');
                                  EasyLoading.dismiss();
                                  _error();
                                }
                              });
                              //////////////
                              ///
                              EasyLoading.dismiss();
                            } else {
                              ///////////////////////
                              ///sinon on fait vibrer le device
                              ///et on afficher un message d'erreur
                              ///
                              Vibration.vibrate(duration: 200);
                              Functions.showBottomSheet(
                                ctxt: context,
                                widget: const ErrorSheetContainer(
                                  text: 'Qr code invalide !',
                                ),
                              ).whenComplete(() {
                                Future.delayed(const Duration(seconds: 5))
                                    .then((_) {
                                  setState(() {
                                    isScanCompleted = false;
                                  });
                                });
                              });
                            }

                            ///////////////////
                            /// finalement on temporise 5s et
                            /// on initialise (isScanCompleted) a false
                            /// pour permettre un scan
                          }
                        },
                      ),
                      const QRScannerOverlay(overlayColour: Colors.white)
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: double.infinity,
                    //color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        setState(() {
                                          isFlashOn = !isFlashOn;
                                        });
                                        mobileScannerController.toggleTorch();
                                      },
                                      child: ActionButton(
                                        child: 'assets/icons/flash_on.svg',
                                        isOn: isFlashOn,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        setState(() {
                                          isFontCamera = !isFontCamera;
                                        });
                                        mobileScannerController.switchCamera();
                                      },
                                      child: ActionButton(
                                        child: 'assets/icons/rotate_camera.svg',
                                        isOn: isFontCamera,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              AppText.medium('ou'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, right: 35, left: 35),
                                child: CustomButton(
                                  color: Palette.primaryColor,
                                  width: double.infinity,
                                  height: 35,
                                  radius: 5,
                                  isSetting: true,
                                  fontsize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  text: 'Utiliser un code de vérification',
                                  onPress: () async {
                                    setState(() {
                                      showLabel1 = true;
                                    });

                                    Navigator.of(context).pushNamed(
                                      VerifyByCodeSheet.routeName,
                                    );
                                    /* if (Platform.isIOS) {
                                      //await Workmanager().cancelAll();
                                      await Workmanager().registerOneOffTask(
                                        "task-identifier",
                                        "task-identifier", // Ignored on iOS
                                        initialDelay: Duration(seconds: 10),
                                        constraints: Constraints(
                                          // connected or metered mark the task as requiring internet
                                          networkType: NetworkType.connected,
                                          // require external power
                                          requiresCharging: true,
                                        ),
                                        // fully supported
                                      );
                                    } else {
                                      await Workmanager().registerPeriodicTask(
                                        "task-identifier",
                                        "task-identifier",
                                        initialDelay: Duration(seconds: 10),
                                        constraints: Constraints(
                                          networkType: NetworkType.connected,
                                        ),
                                      );
                                    } */
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //height: 130,
                          width: double.infinity,
                          decoration: const BoxDecoration(),
                          child: const CopyRight(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  void _error() {
    ///////////////////////
    ///sinon on fait vibrer le device
    ///et on afficher un message d'erreur
    ///
    final size = MediaQuery.of(context).size;
    Vibration.vibrate(duration: 200);
    Functions.showBottomSheet(
      ctxt: context,
      widget: Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Palette.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            AllSheetHeader(),
            Functions.widget404(
              size: size,
              ctxt: context,
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////////

  ///
  ///////////////////////
}
