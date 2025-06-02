import 'package:blood_donation_app/pages/auth/signup/address.dart';
import 'package:blood_donation_app/pages/auth/signup/details.dart';
import 'package:blood_donation_app/pages/auth/signup/otp.dart';
import 'package:blood_donation_app/pages/home/home_page.dart';
import 'package:blood_donation_app/pages/splash/First.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/intentions_de_dons_page.dart';
import 'pages/create_intention_don_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Blood Donation App',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BodySplash(),
        routes: {
          '/intentions-de-dons': (context) => const IntentionsDeDonsPage(),
          '/create-intention-don': (context) => const CreateIntentionDonPage(),
        });
  }
}
