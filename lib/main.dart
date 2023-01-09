
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Schoolclock/constants.dart';
import 'package:Schoolclock/screens/auth/google_SignIn_Screen.dart';
import 'package:Schoolclock/screens/splashScreen.dart';
import 'package:Schoolclock/util/secrets.dart';
//import 'package:timemix/screens/homeScreen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'calendar_client.dart';
import 'screens/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

   var _clientID = new ClientId(Secret.getId(), "");
  const _scopes = [cal.CalendarApi.calendarScope];
  await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) async {
    CalendarClient.calendar = cal.CalendarApi(client);
  });
  
  runApp(MyApp());
}

void prompt(String url) async {
  if (!await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
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
