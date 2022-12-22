
import 'package:Schoolclock/constants.dart';
import 'package:Schoolclock/screens/auth/google_SignIn_Screen.dart';
import 'package:Schoolclock/screens/splashScreen.dart';
import 'package:flutter/material.dart';
//import 'package:timemix/screens/homeScreen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'screens/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
      ),
      home: 
       const SplashScreen(),

      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        SignInScreen.id: (context) => SignInScreen(),
      },
    );
  }
}
