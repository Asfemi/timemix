// ignore_for_file: file_names

//import 'package:flutter_svg_provider/flutter_svg_provider.dart';
//import 'package:cryptocasa/Screens/onboardingScreen.dart';
import 'package:Schoolclock/Logic/google_SignIn_Logic.dart';
import 'package:Schoolclock/constants.dart';
import 'package:Schoolclock/screens/auth/google_SignIn_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

//import 'onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String id = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool initialized = false;

  bool error = false;

  //initialize the firebase project using firebaseCore
  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    await Firebase.initializeApp();
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      setState(() {
        initialized = true;
        print('initialised');
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        error = true;
        print('error');
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    // Show error message if initialization failed
    if (error) {
      if (kDebugMode) {
        print('error');
      }
      return somethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!initialized) {
      if (kDebugMode) {
        print('Loading');
      }
      return loading();
    }

    return EasySplashScreen(
      logo:
          // const Image(
          //   height: 100,
          //   width: 100,
          //   image: Svg('lib/assets/icons/Logo for splash screen.svg'),
          // ),

          Image.asset('lib/assets/icons8-digital-clock-48.png'),
      title: const Text(
        "School Clock",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      showLoader: true,
      loaderColor: kPrimaryColor,
      // loadingText: const Text("Loading..."),
      navigator: AuthService().handleAuthState(),
      durationInSeconds: 1,
    );
  }
}

Widget somethingWentWrong() {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: kPrimaryColor,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
            child: Text(
          'Something Went Wrong',
          style: TextStyle(fontSize: 25, color: kPrimaryColor),
        )),
      ),
    ),
  );
}

Widget loading() {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: kPrimaryColor,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Loading...',
            style: TextStyle(
              fontSize: 25,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    ),
  );
}
