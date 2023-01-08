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
Future<void> displayList(String listId, BuildContext context) async {
  // Get a reference to the list document
  DocumentSnapshot listSnapshot = await FirebaseFirestore.instance.collection('lists').doc(listId).get();
  
  // Get the list data
  String listName = listSnapshot.data['name'];
  String listOwner = listSnapshot.data['owner'];
  List<String> listSubscribers = listSnapshot.data['subscribers'];
  
  // Retrieve and display the user documents for the subscribers
  List<Widget> subscriberCards = [];
  for (String userId in listSubscribers) {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').document(userId).get();
    subscriberCards.add(
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userSnapshot.data['name'], style: Theme.of(context).textTheme.headline6),
              Text(userSnapshot.data['email'], style: Theme.of(context).textTheme.subtitle1),
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


//
// // ignore_for_file: public_member_api_docs
//
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
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
//
// //   // Register the UI isolate's SendPort to allow for communication from the
// //   // background isolate.
// //   IsolateNameServer.registerPortWithName(
// //     port.sendPort,
// //     isolateName,
// //   );
// //   prefs = await SharedPreferences.getInstance();
// //   if (!prefs!.containsKey(countKey)) {
// //     await prefs!.setInt(countKey, 0);
// //   }
//
// //   //runApp(const AlarmManagerExampleApp());
// // }
//
// // /// Example app for Espresso plugin.
// // class AlarmManagerExampleApp extends StatelessWidget {
// //   const AlarmManagerExampleApp({Key? key}) : super(key: key);
//
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       title: 'Flutter Demo',
// //       home: _AlarmHomePage(title: 'Flutter Demo Home Page'),
// //     );
// //   }
// // }
//
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