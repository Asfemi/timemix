import 'package:Schoolclock/components/activityCard.dart';
import 'package:Schoolclock/components/placeHoldingContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../customColors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  static String id = 'home';


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> homeWidgets = [
      Row(
        children: const [
          ActivityCard(),
          ActivityCard(),
        ],
      ),
     const PlaceaholderContainer(),
     const PlaceaholderContainer(),
     const PlaceaholderContainer(),
     const PlaceaholderContainer(),
      const PlaceaholderContainer(),
    ];
    return Scaffold(
      backgroundColor: CustomColors.grey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text("hii",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                background: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Image.asset(
                    //"lib/assets/nathan-dumlao-5Hl5reICevY-unsplash.jpg",
                    "lib/assets/1.jpg",
                    fit: BoxFit.cover,
                  ),
                )),
            expandedHeight: size.height / 2,
            backgroundColor: CustomColors.grey,
            leading: FractionallySizedBox(
              widthFactor: 0.6,
              heightFactor: 0.6,
              //constraints: BoxConstraints(maxHeight: 4, maxWidth: 4),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 2,
                  right: 2,
                  top: 2,
                  bottom: 2,
                ),
                // height: 5,
                // width: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.grey,
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.blue,
                ),
              ),
            ),
            actions: const <Widget>[
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButton<String>(
              //     style: TextStyle(
              //       color: kPrimaryColor,
              //     ),
              //     icon: ClipOval(
              //       child: Image.asset(
              //         'assets/200h.gif',
              //         height: 20,
              //         width: 20,
              //       ),
              //     ),
              //     iconDisabledColor: kPrimaryColor,
              //     iconEnabledColor: Colors.white,
              //     value: selectedSport,
              //     onChanged: (value) {
              //       setState(() {
              //         value = selectedSport;
              //       });
              //     },
              //     items: getDropdownItem(),
              //   ),
              // ),
            ],
            // shape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(30),
            //     bottomRight: Radius.circular(30),
            //   ),
            // ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, position) => homeWidgets[position],
              childCount: homeWidgets.length,
            ), //SliverChildBuildDelegate
          )
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      //todo: add google calender events here
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
        backgroundColor: CustomColors.grey,
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
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.edit),
            onPressed: () {
               //Navigator.of(context).push(
               //MaterialPageRoute(builder: ((context) => const AlarmHomePage(title: 'alarm shooter',))));
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
    );
  }
}
