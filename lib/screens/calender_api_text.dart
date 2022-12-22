// //Yes, it is possible to build a Flutter app that creates an event in Google Calendar using the Google Calendar API. Here is an example of how you could implement this functionality:

// //First, you will need to set up a Google Cloud Platform project and enable the Google Calendar API. Follow the instructions in the Google Calendar API documentation to set this up.

// //In your Flutter app, install the googleapis and googleapis_auth packages from pub.dev. These packages will allow you to use the Google Calendar API in your Flutter app.

// //In your Flutter app, use the googleapis_auth package to authenticate the user and obtain an access token. You will need to specify the calendar.events.insert scope in order to be able to create events in the user's calendar.

// //Once you have an access token, you can use the googleapis package to make requests to the Google Calendar API. To create an event, you will need to make a POST request to the calendarList.insert endpoint, passing in the event details in the request body.

// //Here is an example of how you could make this request using the http package:


// import 'dart:convert';
// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// //for response two
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:googleapis_auth/auth_io.dart' as auth;


// // Replace YOUR_ACCESS_TOKEN with the actual access token
// String accessToken = 'YOUR_ACCESS_TOKEN';

// // Replace YOUR_CALENDAR_ID with the actual calendar ID
// String calendarId = 'YOUR_CALENDAR_ID';

// // Define the event details
// Map<String, dynamic> event = {
//   'summary': 'Event title',
//   'location': 'Event location',
//   'description': 'Event description',
//   'start': {
//     'dateTime': '2022-12-16T09:00:00',
//     'timeZone': 'UTC',
//   },
//   'end': {
//     'dateTime': '2022-12-16T17:00:00',
//     'timeZone': 'UTC',
//   },
//   'attendees': [
//     {'email': 'user1@example.com'},
//     {'email': 'user2@example.com'},
//   ],
// };


// errorMessage() async {
//   // Make the API request to create the event
// http.Response response = await http.post(
//   Url.parse('https://www.googleapis.com/calendar/v3/calendars/$calendarId/events',),
//   headers: {
//     'Authorization': 'Bearer $accessToken',
//     'Content-Type': 'application/json',
//   },
//   body: json.encode(event),
// );

// if (response.statusCode == 200) {
//   // Event was successfully created
//   print('Event created');
// } else {
//   // An error occurred
//   print('Error creating event: ${response.statusCode} ${response.reasonPhrase}');
// }
// }


// //First, you will need to import the necessary dependencies and 
// //configure your Google Calendar API credentials:


// const String SCOPES = 'https://www.googleapis.com/auth/calendar';
// const String CREDENTIALS_FILE = '/path/to/credentials.json';

// Future<auth.Client> _getClient() async {
//   // Read the credentials file and create a new client
//   final auth.ClientId clientId = await auth.readClientIdFromFile(CREDENTIALS_FILE);
//   final auth.AuthClient authClient = await auth.clientViaUserConsent(clientId, SCOPES);
//   return authClient;
// }

// // ext, you can design and implement the UI for your app. This might include a form for 
// //entering the event details and a list of email addresses for the attendees:

// class CreateEventForm extends StatefulWidget {
//   @override
//   _CreateEventFormState createState() => _CreateEventFormState();
// }

// class _CreateEventFormState extends State<CreateEventForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _eventNameController = TextEditingController();
//   final TextEditingController _eventLocationController = TextEditingController();
//   final TextEditingController _eventStartDateController = TextEditingController();
//   final TextEditingController _eventEndDateController = TextEditingController();
//   final TextEditingController _eventAttendeesController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           TextFormField(
//             controller: _eventNameController,
//             decoration: const InputDecoration(
//               labelText: 'Event name',
//             ),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please enter an event name';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             controller: _eventLocationController,
//             decoration: const InputDecoration(
//               labelText: 'Event location',
//             ),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please enter an event location';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             controller: _eventStartDateController,
//             decoration: const InputDecoration(
//               labelText: 'Event start date',
//             ),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please enter an event start date';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             controller: _eventEndDateController,
//             decoration: const InputDecoration(
//               labelText: 'Event end date',
//             ),
//             validator: (value) {
//               if (value!.isEmpty){
//                 return 'Please enter an event start date';
//               }
//               return null;
//             },
//           ),
//         ]
//       ),
//     );
//   }
// }
