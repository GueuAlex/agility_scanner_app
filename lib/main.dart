import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scanner/config/functions.dart';
import 'package:scanner/screens/scanner/widgets/verify_by_code_sheet.dart';

import 'screens/auth/login/login.dart';
import 'screens/home/home.dart';
import 'screens/qr_code_details/qr_code_details_screen.dart';
import 'screens/scanner/scan_screen.dart';
import 'screens/search_by_date/search_by_date_screen.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Timer? _timer;
  _timer = Timer.periodic(Duration(minutes: 1), (timer) {
    Functions.getQrcodesFromApi();
    Functions.getScanHistoriesFromApi();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      locale: const Locale('eu', 'FR'),
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.amber,
        fontFamily: "Gordita",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: SplashScreen.routeName,
      //home: const SplashScreen(),
      //home: const Home(),
      //home: const ScanSreen(),
      //initialRoute: ,
      routes: {
        '/': (ctxt) => const Home(),
        SplashScreen.routeName: (ctxt) => const SplashScreen(),
        ScanSreen.routeName: (ctxt) => const ScanSreen(),
        LoginScreen.routeName: (ctxt) => const LoginScreen(),
        QrCodeDetailsScreen.routeName: (ctxt) => const QrCodeDetailsScreen(),
        VerifyByCodeSheet.routeName: (ctxt) => const VerifyByCodeSheet(),
        SearchByDateScreen.routeName: (ctxt) => const SearchByDateScreen()
      },
    );
  }
}
