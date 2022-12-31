import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
            height: size.height * 0.25,
            width: size.shortestSide / 2.2,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('lib/assets/m.jpg'))),
                        ),
                        Positioned(
                            top: 10,
                            right: 10,
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
                                  Icons.favorite,
                                  color: Colors.blue,
                                  size: 15,
                                )))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ART 544',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        " painting studio",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Icon(
                        Icons.add_location,
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}