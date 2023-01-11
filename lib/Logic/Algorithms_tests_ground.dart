// //import 'package:flutter/material.dart';
//
// //TODO: look up functionalies from chiamaka's app
//
// //TODO: create events
//
// //TODO: add users to event
//
// //TODO: set up calender event picker
//
// //TODO: show events in time table format

// Import the Cloud Firestore package and Flutter widgets
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Define a function that retrieves and displays a list and its subscribers
Future<Scaffold> displayList(String listId, BuildContext context) async {
  //Get a reference to the list document
  DocumentSnapshot listSnapshot = await FirebaseFirestore.instance.collection('lists').doc(listId).get();
  
 // Get the list data
  String listName = listSnapshot['name'];
 String listOwner = listSnapshot['owner'];
  List<String> listSubscribers = listSnapshot['subscribers'];
  
  //Retrieve and display the user documents for the subscribers
 List<Widget> subscriberCards = [];
  for (String userId in listSubscribers) {
   DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
   userSnapshot.get('name');
   subscriberCards.add(
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userSnapshot['name'], style: Theme.of(context).textTheme.headline6),
              Text(userSnapshot['email'], style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
        ),
      ),
    );
  }
  
 // Use a Scaffold widget to display the list data and subscriber cards in the app's user interface
  return Scaffold(
    appBar: AppBar(title: Text(listName)),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Owner: $listOwner', style: Theme.of(context).textTheme.subtitle1),
        ),
        Expanded(
          child: ListView(
            children: subscriberCards,
          ),
        ),
      ],
    ),
  );
}

////set two here
//TODO google sign in for api code example
class GoogleX {
  // import 'dart:async';

// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/people/v1.dart';
// import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '[YOUR_OAUTH_2_CLIENT_ID]',
//   scopes: <String>[PeopleServiceApi.contactsReadonlyScope],
// );

// void main() {
//   runApp(
//     const MaterialApp(
//       title: 'Google Sign In',
//       home: SignInDemo(),
//     ),
//   );
// }

// /// The main widget of this demo.
// class SignInDemo extends StatefulWidget {
//   /// Creates the main widget of this demo.
//   const SignInDemo({Key? key}) : super(key: key);

//   @override
//   State createState() => SignInDemoState();
// }

// /// The state of the main widget.
// class SignInDemoState extends State<SignInDemo> {
//   GoogleSignInAccount? _currentUser;
//   String _contactText = '';

//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       setState(() {
//         _currentUser = account;
//       });
//       if (_currentUser != null) {
//         _handleGetContact();
//       }
//     });
//     _googleSignIn.signInSilently();
//   }

//   Future<void> _handleGetContact() async {
//     setState(() {
//       _contactText = 'Loading contact info...';
//     });

//     // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
//     final auth.AuthClient? client = await _googleSignIn.authenticatedClient();

//     assert(client != null, 'Authenticated client missing!');

//     // Prepare a People Service authenticated client.
//     final PeopleServiceApi peopleApi = PeopleServiceApi(client!);
//     // Retrieve a list of the `names` of my `connections`
//     final ListConnectionsResponse response =
//         await peopleApi.people.connections.list(
//       'people/me',
//       personFields: 'names',
//     );

//     final String? firstNamedContactName =
//         _pickFirstNamedContact(response.connections);

//     setState(() {
//       if (firstNamedContactName != null) {
//         _contactText = 'I see you know $firstNamedContactName!';
//       } else {
//         _contactText = 'No contacts to display.';
//       }
//     });
//   }

//   String? _pickFirstNamedContact(List<Person>? connections) {
//     return connections
//         ?.firstWhere(
//           (Person person) => person.names != null,
//         )
//         .names
//         ?.firstWhere(
//           (Name name) => name.displayName != null,
//         )
//         .displayName;
//   }

//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error); // ignore: avoid_print
//     }
//   }

//   Future<void> _handleSignOut() => _googleSignIn.disconnect();

//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     if (user != null) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text('Signed in successfully.'),
//           Text(_contactText),
//           ElevatedButton(
//             onPressed: _handleSignOut,
//             child: const Text('SIGN OUT'),
//           ),
//           ElevatedButton(
//             onPressed: _handleGetContact,
//             child: const Text('REFRESH'),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           const Text('You are not currently signed in.'),
//           ElevatedButton(
//             onPressed: _handleSignIn,
//             child: const Text('SIGN IN'),
//           ),
//         ],
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Sign In'),
//         ),
//         body: ConstrainedBox(
//           constraints: const BoxConstraints.expand(),
//           child: _buildBody(),
//         ));
//   }
// }
}

//TODO shared peferences code
class Shared_PrefrencesX {
  
// import 'dart:developer' as developer;
// import 'dart:isolate';
// import 'dart:math';
// import 'dart:ui';
//
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
//
// /// The [SharedPreferences] key to access the alarm fire count.
// const String countKey = 'count';
//
// /// The name associated with the UI isolate's [SendPort].
// const String isolateName = 'isolate';
//
// /// A port used to communicate from a background isolate to the UI isolate.
// ReceivePort port = ReceivePort();
//
// /// Global [SharedPreferences] object.
// SharedPreferences? prefs;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Register the UI isolate's SendPort to allow for communication from the
//   // background isolate.
//   IsolateNameServer.registerPortWithName(
//     port.sendPort,
//     isolateName,
//   );
//   prefs = await SharedPreferences.getInstance();
//   if (!prefs!.containsKey(countKey)) {
//     await prefs!.setInt(countKey, 0);
//   }

//   //runApp(const AlarmManagerExampleApp());
// }

// /// Example app for Espresso plugin.
// class AlarmManagerExampleApp extends StatelessWidget {
//   const AlarmManagerExampleApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       home: _AlarmHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

}

//TODO alarm home page   
class AlarmX {
  // class AlarmHomePage extends StatefulWidget {
//   const AlarmHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   AlarmHomePageState createState() => AlarmHomePageState();
// }
//
// class AlarmHomePageState extends State<AlarmHomePage> {
//   int _counter = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     AndroidAlarmManager.initialize();
//
//     // Register for events from the background isolate. These messages will
//     // always coincide with an alarm firing.
//     port.listen((_) async => await _incrementCounter());
//   }
//
//   Future<void> _incrementCounter() async {
//     developer.log('Increment counter!');
//     // Ensure we've loaded the updated count from the background isolate.
//     await prefs?.reload();
//
//     setState(() {
//       _counter++;
//     });
//   }
//
//   // The background
//   static SendPort? uiSendPort;
//
//   // The callback for our alarm
//   @pragma('vm:entry-point')
//   static Future<void> callback() async {
//     developer.log('Alarm fired!');
//     // Get the previous cached count and increment it.
//     final prefs = await SharedPreferences.getInstance();
//     final currentCount = prefs.getInt(countKey) ?? 0;
//     await prefs.setInt(countKey, currentCount + 1);
//
//     // This will be null if we're running in the background.
//     uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
//     uiSendPort?.send(null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textStyle = Theme.of(context).textTheme.headline4;
//     return Scaffold(
//       //appbar
//       appBar: AppBar(
//         title: const Text('algorithms tester'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Alarm fired $_counter times',
//               style: textStyle,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   'Total alarms fired: ',
//                   style: textStyle,
//                 ),
//                 Text(
//                   prefs?.getInt(countKey).toString() ?? '',
//                   key: const ValueKey('BackgroundCountText'),
//                   style: textStyle,
//                 ),
//               ],
//             ),
//
//             ElevatedButton(
//               key: const ValueKey('RegisterOneShotAlarm'),
//               onPressed: () async {
//                 await AndroidAlarmManager.oneShot(
//                   const Duration(seconds: 5),
//                   // Ensure we have a unique alarm ID.
//                   Random().nextInt(pow(2, 31) as int),
//                   callback,
//                   exact: true,
//                   wakeup: true,
//                 );
//               },
//               child: const Text(
//                 'Schedule OneShot Alarm',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
}
