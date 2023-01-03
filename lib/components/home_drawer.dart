import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Logic/google_SignIn_Logic.dart';


class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            color: Colors.white60,
            child: Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user!.photoURL!),
                radius: 30,
              ),
            ),
          ),
          Text(user!.email!),
          SizedBox(height: 20),
          Text(user!.displayName!),
          Expanded(child: Container()),
          TextButton(
              onPressed: () {
                AuthService().signOutFromGoogle();
                Navigator.pop(context);
              },
              child: Text('Sign-Out'))
        ],
      ),
    );
  }
}
