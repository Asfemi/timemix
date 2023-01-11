import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Logic/google_SignIn_Logic.dart';
import '../../calendar_client.dart';
import '../../util/secrets.dart';

class SignInScreen extends StatefulWidget {
//SignInScreen({Key key}) : super(key: key);
  static String id = 'signin';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: Secret.getId(),
    scopes: <String>[cal.CalendarApi.calendarScope],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleCalendarApi();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleCalendarApi() async {
    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    final auth.AuthClient? clientx = await _googleSignIn.authenticatedClient();

    assert(clientx != null, 'Authenticated client missing!');

    void prompt(String url) async {
      if (!await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }

    // Prepare a People Service authenticated client.
    var _clientID = ClientId(Secret.getId());
    const _scopes = [cal.CalendarApi.calendarScope];
    //if (onCurrentUserChanged){}
    await clientViaUserConsent(_clientID, _scopes, prompt)
        .then((AuthClient client) async {
      CalendarClient.calendar = cal.CalendarApi(clientx!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.red,
            ],
          ),
        ),
        child: Card(
          margin:
              const EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
          elevation: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "SCHOOL CLOCK",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: MaterialButton(
                  color: Colors.teal[100],
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('lib/assets/icons8-google-48.png'),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text("Sign In with Google")
                    ],
                  ),

                  // by onpressed we call the function signup function
                  onPressed: () {
                    AuthService().SignInWithGoogle();
                    //signup(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
