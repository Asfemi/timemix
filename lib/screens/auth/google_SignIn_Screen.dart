//SignInScreen

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Schoolclock/screens/homeScreen.dart';

import '../../Logic/google_SignIn_Logic.dart';


class SignInScreen extends StatefulWidget {
//SignInScreen({Key key}) : super(key: key);
static String id = 'signin';
@override
_SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


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
		margin: const EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
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
				onPressed: (){
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
