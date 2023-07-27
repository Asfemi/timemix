
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Schoolclock/constants.dart';
import 'package:Schoolclock/screens/auth/google_SignIn_Screen.dart';
import 'package:Schoolclock/screens/splashScreen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'screens/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';


//Future<void> 
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isWindows){
    await Firebase.initializeApp();
  }
  
  runApp(MyApp());
}



// ignore: use_key_in_widget_constructors
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
        SplashScreen.id: (context) => const SplashScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        SignInScreen.id: (context) => SignInScreen(),
      },
    );
  }
}
