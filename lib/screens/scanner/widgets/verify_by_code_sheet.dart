import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vibration/vibration.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/qr_code_model.dart';
import '../../../remote_service/remote_service.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/custom_button.dart';
import 'error_sheet_container.dart';
import 'infos_column.dart';
import 'sheet_container.dart';

class VerifyByCodeSheet extends StatefulWidget {
  static const routeName = 'verifyByCodeSheet';
  const VerifyByCodeSheet({
    super.key,
  });

  @override
  State<VerifyByCodeSheet> createState() => _VerifyByCodeSheetState();
}

class _VerifyByCodeSheetState extends State<VerifyByCodeSheet> {
  ////////////////
  ///
  AudioCache player = AudioCache();
  ///////////////:
  ///
  bool showLabel1 = true;
  final TextEditingController codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String prefix = 'AG-';
    final Widget codeTextField = TextField(
      controller: codeController,
      keyboardType: TextInputType.text,
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
        prefix: AppText.medium(prefix),
        label: showLabel1
            ? AppText.medium('Entrer le code de vérification')
            : Container(),
        border: InputBorder.none,
      ),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? CupertinoIcons.back : CupertinoIcons.arrow_left,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        height: size.height / 1.3,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Palette.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            //const AllSheetHeader(),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  AppText.medium('Vérifier le code'),
                  AppText.small(
                    'Utiliser le code pour afficher les infos du visiteur',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 35, left: 35, top: 30),
                    child: InfosColumn(
                      height: 60,
                      opacity: 0.2,
                      label: 'Code',
                      widget: Expanded(
                        child: codeTextField,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 35, left: 35, top: 10),
                    child: CustomButton(
                      color: Palette.primaryColor,
                      width: double.infinity,
                      height: 35,
                      radius: 5,
                      text: 'Vérifier',
                      onPress: () async {
                        if (codeController.text.trim().isEmpty) {
                          Functions.showToast(
                            msg: 'Le champ code est obligatoire !',
                          );
                        } else {
                          final codePattern = RegExp(r'^AG-\d{2}-\d+$');
                          String code = '$prefix${codeController.text}';

                          if (codePattern.hasMatch(code)) {
                            EasyLoading.show();
                            // fetch data
                            var postData = {
                              "code_visite": '$prefix${codeController.text}',
                            };
                            await RemoteService()
                                .postData(
                              endpoint: 'qrcodes/verifications',
                              postData: postData,
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

                                player.play('images/soung.mp3');
                                Functions.showBottomSheet(
                                  ctxt: context,
                                  widget: SheetContainer(
                                    visite: visite,
                                    // agent: _agent!,
                                  ),
                                );
                                EasyLoading.dismiss();
                              } else {
                                //print('object');
                                EasyLoading.dismiss();
                                _error(size: size);
                              }
                            });
                            //////////////
                            ///
                            EasyLoading.dismiss();
                          } else {
                            EasyLoading.dismiss();
                            ///////////////////////
                            ///sinon on fait vibrer le device
                            ///et on afficher un message d'erreur
                            ///
                            Vibration.vibrate(duration: 200);
                            Functions.showBottomSheet(
                              ctxt: context,
                              widget: const ErrorSheetContainer(
                                text: 'Code Invalide!',
                              ),
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _error({required Size size}) {
    ///////////////////////
    ///sinon on fait vibrer le device
    ///et on afficher un message d'erreur
    ///
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
}
