import 'package:Schoolclock/Logic/google_SignIn_Logic.dart';
import 'package:Schoolclock/components/activityCard.dart';
import 'package:Schoolclock/components/placeHoldingContainer.dart';
import 'package:Schoolclock/model/eventInfo.dart';
import 'package:Schoolclock/screens/create_event_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import '../components/home_drawer.dart';
import '../customColors.dart';
import '../util/storage.dart';
import 'edit_events_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String id = 'home';
  //TODO: get illustrations for the pages

  //todo: make the ui adapt the functionalities

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage();
    Size size = MediaQuery.of(context).size;

    User? user = FirebaseAuth.instance.currentUser;
   //todo: look into 'app check' to avoid excess billings
    
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: HomeDrawer(user: user),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.blueAccent,
            //CustomColor.dark_blue,
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      
      floatingActionButton: ExpandableFab(
        key: key,
        // duration: const Duration(seconds: 1),
        // distance: 60.0,
        // type: ExpandableFabType.up,
        // fanAngle: 70,
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
        // foregroundColor: Colors.amber,
        backgroundColor: CustomColor.grey,
        // closeButtonStyle: const ExpandableFabCloseButtonStyle(
        //   child: Icon(Icons.abc),
        //   foregroundColor: Colors.deepOrangeAccent,
        //   backgroundColor: Colors.lightGreen,
        // ),
        overlayStyle: ExpandableFabOverlayStyle(
          // color: Colors.black.withOpacity(0.5),
          blur: 5,
        ),
        children: [
          //edit event screen
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.edit),
            onPressed: () {
              
          
              
              //todo: edit event
              //brainstorm on the proper app logic
              //look into using provider and change notifier to handle the state of the ap
              //i have looked into provider now, bloc in next
              //todo: set notification type.
              Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) =>  CreateEventScreen())));
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.search),
            onPressed: () {
              // Navigator.of(context).push(
              // MaterialPageRoute(builder: ((context) => const NextPage())));
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.share),
            onPressed: () {
              // final state = key.currentState;
              // if (state != null) {
              //  debugPrint('isOpen:${state.isOpen}');
              //  state.toggle();
              // }
            },
          ),
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 8.0),
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: storage.retrieveEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.docs.isNotEmpty == true) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic>? eventInfo = snapshot.data?.docs[index].data() as Map<String, dynamic>?;

                      EventInfo event = EventInfo.fromMap(eventInfo!);

                      DateTime startTime = DateTime.fromMillisecondsSinceEpoch(event.startTimeInEpoch);
                      DateTime endTime = DateTime.fromMillisecondsSinceEpoch(event.endTimeInEpoch);

                      String startTimeString = DateFormat.jm().format(startTime);
                      String endTimeString = DateFormat.jm().format(endTime);
                      String dateString = DateFormat.yMMMMd().format(startTime);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            //todo: look into better routing solutions
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditEventScreen(event: event),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  top: 16.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      event.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                      child: Text(
                                        event.link.toString(),
                                        style: TextStyle(
                                          color: Colors.blueGrey.withOpacity(0.5),
                                         fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 5,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dateString,
                                              style: const TextStyle(
                                                color: Colors.cyan,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            Text(
                                              '$startTimeString - $endTimeString',
                                              style: const TextStyle(
                                                color: Colors.cyan,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Events',
                      style: TextStyle(
                        color: Colors.black38,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }
              }
              
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            },
          ),
        ),
      ),
      
      //TODO: what i have to do moving forword
      // ctrl+shift+p to open adb commands
      //look into firebase and resolve the timeout issue
      //ask gpt on how to display the event in the google calender itself
      //ask gpt on how to delete the task after the event finishes 
      //ask gpt om how to set it to be reoccurring
      //set up the notifications
      //set up the time table look
      //change up the ui

      );
  }
}
