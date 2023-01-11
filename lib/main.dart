
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Schoolclock/constants.dart';
import 'package:Schoolclock/screens/auth/google_SignIn_Screen.dart';
import 'package:Schoolclock/screens/splashScreen.dart';
import 'package:Schoolclock/util/secrets.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
//import 'package:timemix/screens/homeScreen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'calendar_client.dart';
import 'screens/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId: Secret.getId(),
  scopes: <String>[cal.CalendarApi.calendarScope],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      if (account != null) {
        var httpClient = (await _googleSignIn.authenticatedClient())!;
      }
  });
  

  var _clientID =  ClientId(Secret.getId());
  const _scopes = [cal.CalendarApi.calendarScope];
  //if (onCurrentUserChanged){}
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
