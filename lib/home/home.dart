import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:user/rent/rent_bus.dart';
import 'package:user/search%20bus/search_bus.dart';
import '../color/colors.dart';
import '../rent/rent.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List addList = [
    {"addSno": "1", "addBanner": "assets/images/8.jpeg"},
    {"addSno": "2", "addBanner": "assets/images/7.jpeg"},
    {"addSno": "3", "addBanner": "assets/images/6.jpeg"},
    {"addSno": "4", "addBanner": "assets/images/5.jpeg"},
    {"addSno": "5", "addBanner": "assets/images/4.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text('Home', style: TextStyle(color: white)),
        ),
        body: ListView(
          children: [
            CarouselSlider(
              items: [
                for (int i = 0; i < addList.length; i++)
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // Image.asset("assets/images/$i.jpeg")
                        image: AssetImage("${addList[i]['addBanner']}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 1,
              ),
            ),
            Container(
              color: Color(0xFDF1F6F6),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchBus()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.white,
                              surfaceTintColor: white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/search.png',
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Find a Bus ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Rent()),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                child: Card(
                                  color: Colors.white,
                                  surfaceTintColor: white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/bus-stop.png',
                                          width: 45,
                                          height: 45,
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Trip Calculate',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RentBus()),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                child: Card(
                                  color: Colors.white,
                                  surfaceTintColor: white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/deal.png',
                                          width: 45,
                                          height: 45,
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Rent a Bus',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        // child: Card(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        //   elevation: 1,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Image.asset(
                        //           'assets/images/booking.png',
                        //           width: 45,
                        //           height: 45,
                        //         ),
                        //       ),
                        //       const Padding(
                        //           padding: EdgeInsets.all(8),
                        //           child: Text(
                        //             'Booking',
                        //             style: TextStyle(
                        //                 fontSize: 16,
                        //                 color: Colors.black,
                        //                 fontWeight: FontWeight.bold),
                        //           )),
                        //     ],
                        //   ),
                        // ),
                      )),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Expanded(
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => const SearchBus()),
                  //           );
                  //         },
                  //         child: Padding(
                  //           padding: EdgeInsets.all(10),
                  //           child: Card(
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(5),
                  //             ),
                  //             elevation: 1,
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: <Widget>[
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Image.asset(
                  //                     'assets/images/search.png',
                  //                     width: 45,
                  //                     height: 45,
                  //                   ),
                  //                 ),
                  //                 const Padding(
                  //                     padding: EdgeInsets.all(8),
                  //                     child: Text(
                  //                       'Find a Bus ',
                  //                       style: TextStyle(
                  //                           fontSize: 16,
                  //                           color: black,
                  //                           fontWeight: FontWeight.bold),
                  //                     )),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: GestureDetector(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => const Rent()),
                  //             );
                  //           },
                  //           child: Padding(
                  //             padding: EdgeInsets.all(10),
                  //             child: SizedBox(
                  //               child: Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(5),
                  //                 ),
                  //                 elevation: 1,
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.center,
                  //                   children: <Widget>[
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: Image.asset(
                  //                         'assets/images/deal.png',
                  //                         width: 45,
                  //                         height: 45,
                  //                       ),
                  //                     ),
                  //                     const Padding(
                  //                         padding: EdgeInsets.all(8),
                  //                         child: Text(
                  //                           'Rent a Bus',
                  //                           style: TextStyle(
                  //                               fontSize: 16,
                  //                               color: Colors.black,
                  //                               fontWeight: FontWeight.bold),
                  //                         )),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           )),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 130,
                  )
                ],
              ),
            ),
            Container(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < 9; i++)
                    Container(
                      padding: EdgeInsets.all(10),
                      width: 300,
                      child: Image.asset("assets/images/$i.jpeg"),
                    ),
                ],
              ),
            ),
          ],
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}