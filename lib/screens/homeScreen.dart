import 'package:flutter/material.dart';
import 'package:timemix/customColors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> homeWidgets = [
      Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 50,
          width: 500,
          color: Colors.purple),
      Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 50,
          width: 500,
          color: Colors.red),
      Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 50,
          width: 500,
          color: Colors.yellow),
      Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 50,
          width: 500,
          color: Colors.green),
      Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 50,
          width: 500,
          color: Colors.blue),
      Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 50,
        width: 500,
        color: Colors.amber,
      ),
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
                title: const Text("heyy",
                    style: const TextStyle(
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
                    "lib/assets/aron-visuals-BXOXnQ26B7o-unsplash.jpg",
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
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
        // body: Column(
        //   children: [
        //     Expanded(
        //         flex: 20,
        //         child: Container(
        //           decoration: const BoxDecoration(
        //             image: DecorationImage(
        //               fit: BoxFit.fill,
        //               image: AssetImage(
        //                   'lib/assets/nathan-dumlao-5Hl5reICevY-unsplash.jpg',),
        //             ),
        //           ),
        //         )),
        //     Expanded(flex: 15, child: Container()),
        //   ],
        // ),
      ),
    );
  }
}
