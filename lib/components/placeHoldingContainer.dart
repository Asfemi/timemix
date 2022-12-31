import 'package:flutter/material.dart';

class PlaceaholderContainer extends StatelessWidget {
  const PlaceaholderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          height: size.shortestSide/2,
          width: size.shortestSide/2,
          color: Colors.blue,);
  }
}