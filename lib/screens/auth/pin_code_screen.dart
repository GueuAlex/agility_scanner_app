import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/config/functions.dart';
import 'package:scanner/screens/scanner/scan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/palette.dart';

class PincodeScreen extends StatefulWidget {
  static String routeName = "pincode_screen";
  const PincodeScreen({super.key});

  @override
  State<PincodeScreen> createState() => _PincodeScreenState();
}

class _PincodeScreenState extends State<PincodeScreen> {
  //////::
  final TextEditingController pinController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  @override
  Widget build(BuildContext context) {
    final pinCodeField = PinCodeTextField(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      appContext: context,
      length: 6,
      autoFocus: true,
      keyboardType: TextInputType.number,
      cursorColor: Palette.secondaryColor.withOpacity(1),
      autoDismissKeyboard: true,
      //obscureText: true,
      animationType: AnimationType.fade,
      //scrollPadding: const EdgeInsets.all(0.0),
      textStyle: const TextStyle(color: Palette.whiteColor),
      pinTheme: PinTheme(
        //fieldOuterPadding: const EdgeInsets.all(0.0),

        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(100),
        fieldHeight: 45,
        fieldWidth: 45,

        activeFillColor: Palette.appPrimaryColor,
        selectedFillColor: Palette.appPrimaryColor.withOpacity(0.2),
        selectedColor: Palette.appPrimaryColor.withOpacity(0.2),
        activeColor: Palette.appPrimaryColor.withOpacity(0.2),
        inactiveFillColor: Palette.appPrimaryColor.withOpacity(0.2),
        inactiveColor: Palette.appPrimaryColor.withOpacity(0.2),
      ),
      animationDuration: const Duration(milliseconds: 300),
      //backgroundColor: Colors.blue.shade50,
      enableActiveFill: true,
      errorAnimationController: errorController,
      controller: pinController,
      onCompleted: (v) async {
        if (v == '723091') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('asAuth', true);
          Functions.showLoadingSheet(ctxt: context);
          Future.delayed(const Duration(seconds: 3)).then((_) {
            Navigator.pop(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
              ScanSreen.routeName,
              (route) => false,
            );
          });
        } else {
          Functions.showToast(msg: 'Code incorrect !');
        }
      },
      onChanged: (value) {
        //print(value);
      },
      beforeTextPaste: (text) {
        // print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.medium(
              'Code d\'authentification',
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: pinCodeField,
            )
          ],
        ),
      ),
    );
  }
}
