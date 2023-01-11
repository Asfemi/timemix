import 'package:Schoolclock/screens/auth/google_SignIn_Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Schoolclock/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
//function to implement the google signin

// // creating firebase instance
// final FirebaseAuth auth = FirebaseAuth.instance;

// Future<void> signup(BuildContext context) async {
// 	final GoogleSignIn googleSignIn = GoogleSignIn();
// 	final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
// 	if (googleSignInAccount != null) {
// 	final GoogleSignInAuthentication googleSignInAuthentication =
// 		await googleSignInAccount.authentication;
// 	final AuthCredential authCredential = GoogleAuthProvider.credential(
// 		idToken: googleSignInAuthentication.idToken,
// 		accessToken: googleSignInAuthentication.accessToken);

// 	// Getting users credential
// 	UserCredential result = await auth.signInWithCredential(authCredential);
// 	User? user = result.user;

// 	if (result != null) {
// 		Navigator.pushReplacement(
// 			context, MaterialPageRoute(builder: (context) => HomeScreen()));
// 	} // if result not null we simply call the MaterialpageRoute,
// 		// for go to the HomePage screen
// 	}
// }

class AuthService {
//handle AuthState
  //this determines if the user is authenticated
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return SignInScreen();
        }
      }),
    );
  }

//Sign in with google
  SignInWithGoogle() async {
    //triger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(
          scopes: <String>["email"]
            //cal.CalendarApi.calendarScope
          ).signIn();

    //obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //create a credential
    final Credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //once signed in, return the usercredential
    return await FirebaseAuth.instance.signInWithCredential(Credential);
  }

//sign out from google
  signOutFromGoogle() {
    FirebaseAuth.instance.signOut();
  }
}
//