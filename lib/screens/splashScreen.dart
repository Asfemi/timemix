// ignore_for_file: file_names

//import 'package:flutter_svg_provider/flutter_svg_provider.dart';
//import 'package:cryptocasa/Screens/onboardingScreen.dart';
import 'package:Schoolclock/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

//import 'onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
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
      //navigator: const OnBoardingPage(),
      durationInSeconds: 1,
    );
  }
}
