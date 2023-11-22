import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:scanner/screens/add_delivering/add_deli_screen.dart';
import 'package:scanner/screens/auth/pin_code_screen.dart';
import 'package:scanner/screens/delivering/deliverig_screen.dart';

import 'bloc/internet_bloc/internet_bloc.dart';
import 'config/functions.dart';
import 'dependency_injection.dart';
import 'screens/auth/login/login.dart';
import 'screens/home/home.dart';
import 'screens/qr_code_details/qr_code_details_screen.dart';
import 'screens/scanner/scan_screen.dart';
import 'screens/scanner/widgets/verify_by_code_sheet.dart';
import 'screens/search_by_date/deli_search_by_date_screen.dart';
import 'screens/search_by_date/search_by_date_screen.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Timer.periodic(Duration(minutes: 1), (timer) {
    Functions.getQrcodesFromApi();
    Functions.getScanHistoriesFromApi();
    Functions.allEntrepise();
    Functions.allLivrason();
  });

  runApp(
    BlocProvider(
      create: (context) => InternetBloc(),
      child: const MyApp(),
    ),
  );
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return GetMaterialApp(
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
        SearchByDateScreen.routeName: (ctxt) => const SearchByDateScreen(),
        DeliveringScreen.routeName: (ctxt) => const DeliveringScreen(),
        AddDeliScree.routeName: (ctxt) => const AddDeliScree(),
        DeliSearchByDateScreen.routeName: (ctxt) =>
            const DeliSearchByDateScreen(),
        PincodeScreen.routeName: (ctxt) => const PincodeScreen(),
      },
    );
  }
}
