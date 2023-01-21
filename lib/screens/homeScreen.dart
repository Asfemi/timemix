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
  //todo: restructure the entire code
  //TODO: get illustrations for the pages
  //todo: trim the ui
  //todo: make the ui adapt the functionalities

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage();
    Size size = MediaQuery.of(context).size;

    User? user = FirebaseAuth.instance.currentUser;
   //todo: look into 'app check' to avoid excess billings
    List<Widget> homeWidgets = [
      const PlaceaholderContainer(),
      const PlaceaholderContainer(),
    ];
    return Scaffold(
      backgroundColor: CustomColor.grey,
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
      
      // body: CustomScrollView(
      //   slivers: <Widget>[
      //     SliverAppBar(
      //       snap: false,
      //       pinned: true,
      //       floating: false,
      //       flexibleSpace: FlexibleSpaceBar(
      //           centerTitle: true,
      //           title: const Text("hii",
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 16.0,
      //               )),
      //           background: Container(
      //             clipBehavior: Clip.hardEdge,
      //             decoration: const BoxDecoration(
      //                 borderRadius: BorderRadius.only(
      //                     bottomLeft: Radius.circular(40),
      //                     bottomRight: Radius.circular(40))),
      //             child: Image.asset(
      //               //"lib/assets/nathan-dumlao-5Hl5reICevY-unsplash.jpg",
      //               "lib/assets/1.jpg",
      //               fit: BoxFit.cover,
      //             ),
      //           )),
      //       expandedHeight: size.height / 2,
      //       backgroundColor: CustomColors.grey,
      //       leading: FractionallySizedBox(
      //         widthFactor: 0.6,
      //         heightFactor: 0.6,
      //         //constraints: BoxConstraints(maxHeight: 4, maxWidth: 4),
      //         child: Container(
      //           padding: const EdgeInsets.only(
      //             left: 2,
      //             right: 2,
      //             top: 2,
      //             bottom: 2,
      //           ),
      //           // height: 5,
      //           // width: 5,
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             color: CustomColors.grey,
      //           ),
      //           child: const Icon(
      //             Icons.menu,
      //             color: Colors.blue,
      //           ),
      //         ),
      //       ),
      //       actions: const <Widget>[
             
      //      ],
            
      //     ),
      //     SliverList(
      //       delegate: SliverChildBuilderDelegate(
      //         (context, index) => 
      //         const Padding(
      //           padding: EdgeInsets.only(
      //           left: 16.0,
      //           right: 16.0,
      //           ),
      //         ),
      //        // homeWidgets[index],
      //         childCount: homeWidgets.length,
      //       ), //SliverChildBuildDelegate
      //     )
      //   ],
      // ),
      );
  }
}
