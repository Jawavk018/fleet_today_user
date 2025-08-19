import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/maps/rent-via.dart';
import 'package:user/rent/rent_bus_list.dart';
import 'package:user/service/apiservice/apiservice.dart';
import 'package:user/service/commonservice/commonservice.dart';
import 'package:user/service/tokenservice/tokenservice.dart';
import '../color/colors.dart';
import '../maps/RentSource.dart';
import 'package:geocoding/geocoding.dart';

class Rent extends StatefulWidget {
  const Rent({Key? key}) : super(key: key);

  @override
  State<Rent> createState() => _RentState();
}

class _RentState extends State<Rent> {
  TextEditingController sourcePlace = TextEditingController();
  TextEditingController destinationPlace = TextEditingController();
  TextEditingController viaPlace = TextEditingController();
  TextEditingController startDateInput = TextEditingController();
  TextEditingController tripEndDate = TextEditingController();
  TextEditingController returnSourcePlace = TextEditingController();
  TextEditingController returnDestinationPlace = TextEditingController();
  TextEditingController returnViaPlace = TextEditingController();
  ApiService apiService = ApiService();
  CommonService commonService = CommonService();
  TokenService tokenService = TokenService();
  double forwardDis = 0;
  double returnDis = 0;
  var user;
  var destination = {};
  var source = {};
  List viaList = [];
  List returnViaList = [];
  var returnSource = {};
  var returnDestination = {};
  List returnTypeList = [];
  Timer? _debounce;
  bool isSwitched = false;
  bool isLoading = false;
  bool isReturnTrip = false;
  bool isCheckController = false;
  String? tripType = '72'; //no radio button will be selected on initial

  String sourceLocation = '';
  String destinationLocation = '';
  String returnDestLocation = '';

  var startDate;


  @override
  void initState() {
    // checkTextController();
    user = tokenService.getUser();
    getTripType();
    print("$user");
    setState(() {});
    // TODO: implement initState
    super.initState();
    // getCurrentSource();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        iconTheme: const IconThemeData(
          color: white, //change your color here
        ),
        title: const Text('Rent', style: TextStyle(color: white)),
      ),
      body: ListView(
        children: [
          Card(
            color: Colors.white,
            surfaceTintColor: white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    for (int i = 0; i < returnTypeList.length; i++)
                      Expanded(
                        child: RadioListTile(
                          title: Text("${returnTypeList[i]['cdValue']}"),
                          value: "${returnTypeList[i]['codesDtlSno']}",
                          groupValue: tripType,
                          onChanged: (value) {
                            setState(() {
                              clearRoute();
                              tripType =
                                  returnTypeList[i]['codesDtlSno'].toString();
                              if (tripType == '72') {
                                isReturnTrip = false;
                                isSwitched = false;
                              }
                            });
                          },
                        ),
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Forward Trip Details",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: false,
                    readOnly: true,
                    controller: sourcePlace,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RentSource(type: 'source')),
                      );
                      print("resss$result");
                      if (result != null) {
                        source = result;
                        // sourcePlace.text = result['place'];
                        print('${result['place']}');
                        sourceLocation = result['place'];
                        List<String> parts = sourceLocation.split(',');
                        String result1 = parts[0].trim();
                        sourceLocation = result1;
                        print('$sourceLocation');
                        sourcePlace.text = sourceLocation;
                      }
                      // getCurrentSource();
                    },
                    onChanged: _on_change_validate(),
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.location_on),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/get-on-bus.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      labelText: tripType == '72'?'Pickup Location':'Pickup and Drop Location ',
                      border: OutlineInputBorder(),
                      hintText: "",
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: startDateInput,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month),
                            labelText: 'Pickup Date',
                            border: OutlineInputBorder(),
                            hintText: "",
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                startDateInput.text = formattedDate;
                                startDate = formattedDate;
                                print('$startDate');
                                // checkTextController();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: tripEndDate,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month),
                            labelText: 'Drop Date',
                            border: OutlineInputBorder(),
                            hintText: "",
                          ),
                          readOnly: true,
                          onTap: () async {
                            if (startDateInput.text.isNotEmpty) {
                              var inputFormat = DateFormat('dd-MM-yyyy');
                              var date1 = inputFormat.parse(startDate);
                              var outputFormat = DateFormat('yyyy-MM-dd');
                              DateTime date3 = DateTime.parse(outputFormat.format(date1));
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: date3,
                                firstDate: date3,
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                                setState(() {
                                  tripEndDate.text = formattedDate;
                                  print('$tripEndDate.text');
                                  // checkTextController();
                                });
                              }
                            }else{
                              commonService?.presentToast("Please Select Pickup Date");
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                tripType == '72'?Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: false,
                    readOnly: true,
                    controller: destinationPlace,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RentSource(type: 'destination')),
                      );

                      if (result != null) {
                        destination = result;
                        // destinationPlace.text = result['place'];
                        destinationLocation = result['place'];
                        List<String> parts = destinationLocation.split(',');
                        String result1 = parts[0].trim();
                        destinationLocation = result1;
                        print('$destinationLocation');
                        destinationPlace.text = destinationLocation;
                        makeLatLong();
                      }
                    },
                    onChanged: _on_change_validate(),
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.bus_alert_outlined),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/get-off-bus.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      labelText: 'Drop Location',
                      border: OutlineInputBorder(),
                      hintText: "",
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ):Container(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: viaPlace,
                    autofocus: false,
                    readOnly: true,
                    onTap: () async {
                      print(tripType);
                      if(tripType == '72'){
                        if (source.isNotEmpty && destination.isNotEmpty) {
                          // print();
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RentViaMap(source, destination, via: viaList, type: 'via', tripType: '72')),
                          );
                          if (result != null) {
                            viaList = result;
                            print('$viaList');
                            var data = [];
                            for (int i = 0; i < viaList.length; i++) {
                              String inputString = viaList[i]['place'];
                              List<String> parts = inputString.split(',');
                              String result = parts[0].trim(); // trim() removes leading and trailing whitespace
                              data.add(result);
                            }
                            viaPlace.text = data.toString().substring(1, data.toString().length - 1);
                            makeLatLong();
                          } else {
                            viaList = [];
                            viaPlace.text = '';
                          }
                        } else {
                          commonService.presentToast(
                              "Before select via please select source and destination");
                        }
                      }else{
                        if (source.isNotEmpty) {
                          // print();
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => RentViaMap(source, destination, via: viaList, type: 'via')),
                                builder: (context) => RentViaMap(source, null, via: viaList, type: 'via', tripType: '73')),
                          );
                          if (result != null) {
                            viaList = result;
                            print('$viaList');
                            var data = [];
                            for (int i = 0; i < viaList.length; i++) {
                              String inputString = viaList[i]['place'];
                              List<String> parts = inputString.split(',');
                              String result = parts[0].trim(); // trim() removes leading and trailing whitespace
                              data.add(result);
                            }
                            viaPlace.text = data.toString().substring(1, data.toString().length - 1);
                            makeRetLatLong();
                          } else {
                            viaList = [];
                            viaPlace.text = '';
                          }
                        } else {
                          commonService.presentToast(
                              "Before select via please select source and destination");
                        }
                      }

                    },
                    onChanged: _on_change_validate(),
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.route_outlined),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/via-route.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      labelText: 'Via',
                      border: OutlineInputBorder(),
                      hintText: "",
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // tripType == '73'
                //     ? ListTile(
                //         title: const Text(
                //           "Return Trip",
                //           style: TextStyle(fontSize: 18),
                //         ),
                //         trailing: Switch(
                //           value: isSwitched,
                //           onChanged: (value) {
                //             setState(() {
                //               isSwitched = value;
                //               isReturnTrip = false;
                //               print("$isSwitched");
                //               if (isSwitched) {
                //                 showDialog(
                //                   barrierDismissible: false,
                //                   context: context,
                //                   builder: (BuildContext context) =>
                //                       _buildPopupDialog(context),
                //                 );
                //               }
                //             });
                //           },
                //           activeTrackColor: primary,
                //           activeColor: primary,
                //         ),
                //       )
                //     : Container(),
                // isReturnTrip
                //     ? Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Padding(
                //             padding: EdgeInsets.all(10),
                //             child: Text("Return Trip Details",
                //                 style: TextStyle(
                //                     fontSize: 16, fontWeight: FontWeight.w500)),
                //           ),
                //           Row(
                //             children: [
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(10.0),
                //                   child: TextField(
                //                     autofocus: false,
                //                     readOnly: true,
                //                     controller: returnSourcePlace,
                //                     onChanged: _on_change_validate(),
                //                     decoration:  InputDecoration(
                //                       // prefixIcon: Icon(Icons.map),
                //                       prefixIcon: Padding(
                //                         padding:  const EdgeInsets.all(10.0),
                //                         child: Image.asset(
                //                           'assets/images/get-on-bus.png',
                //                           width: 20,
                //                           height: 20,
                //                           fit: BoxFit.fill,
                //                         ),
                //                       ),
                //                       labelText: 'Source',
                //                       border: OutlineInputBorder(),
                //                       hintText: "",
                //                     ),
                //                     textInputAction: TextInputAction.next,
                //                   ),
                //                 ),
                //               ),
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(10.0),
                //                   child: TextField(
                //                     autofocus: false,
                //                     readOnly: true,
                //                     controller: returnDestinationPlace,
                //                     onTap: () async {
                //                       final result = await Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                             builder: (context) => RentViaMap(
                //                                 source, destination,
                //                                 via: viaList,
                //                                 type: 'returnDestination')),
                //                       );
                //                       if (result != null) {
                //                         returnDestination = result;
                //                         // returnDestinationPlace.text = result['place'];
                //                         returnDestLocation = result['place'];
                //                         List<String> parts = returnDestLocation.split(',');
                //                         String result1 = parts[0].trim();
                //                         returnDestLocation = result1;
                //                         print('$returnDestLocation');
                //                         makeRetLatLong();
                //                         returnDestinationPlace.text = returnDestLocation;
                //                       }
                //                     },
                //                     onChanged: _on_change_validate(),
                //                     decoration:  InputDecoration(
                //                       // prefixIcon: Icon(Icons.drive_eta_rounded),
                //                       prefixIcon: Padding(
                //                         padding: const EdgeInsets.all(10.0),
                //                         child: Image.asset(
                //                           'assets/images/get-off-bus.png',
                //                           width: 20,
                //                           height: 20,
                //                           fit: BoxFit.fill,
                //                         ),
                //                       ),
                //                       labelText: ' Destination',
                //                       border: OutlineInputBorder(),
                //                       hintText: "",
                //                     ),
                //                     textInputAction: TextInputAction.next,
                //                   ),
                //                 ),
                //               )
                //             ],
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.all(10.0),
                //             child: TextField(
                //               controller: returnViaPlace,
                //               autofocus: false,
                //               readOnly: true,
                //               onTap: () async {
                //                 if (destination.isNotEmpty) {
                //                   final result = await Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) => RentViaMap(source, destination, returnDes: returnDestination, via: viaList, returnvia: returnViaList, type: 'returnVia')),
                //                   );
                //                   if (result != null) {
                //                     returnViaList = result;
                //                     var data = [];
                //                     for (int i = 0; i < returnViaList.length; i++) {
                //                       String inputString = returnViaList[i]['place'];
                //                       List<String> parts = inputString.split(',');
                //                       String result = parts[0].trim(); // trim() removes leading and trailing whitespace
                //                       data.add(result);
                //                     }
                //                     returnViaPlace.text = data.toString().substring(1, data.toString().length - 1);
                //                     makeRetLatLong();
                //                   } else {
                //                     returnViaList = [];
                //                   }
                //                 } else {
                //                   commonService.presentToast(
                //                       "Before select via please select source and destination");
                //                 }
                //               },
                //               onChanged: _on_change_validate(),
                //               decoration:  InputDecoration(
                //                 // prefixIcon: Icon(Icons.route_outlined),
                //                 prefixIcon: Padding(
                //                   padding: const EdgeInsets.all(10.0),
                //                   child: Image.asset(
                //                     'assets/images/via-route.png',
                //                     width: 20,
                //                     height: 20,
                //                     fit: BoxFit.fill,
                //                   ),
                //                 ),
                //                 labelText: 'Return Via',
                //                 border: OutlineInputBorder(),
                //                 hintText: "",
                //               ),
                //               textInputAction: TextInputAction.next,
                //             ),
                //           ),
                //         ],
                //       )
                //     : Container(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCheckController ? primary : secondary,
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () {
                      isCheckController ? goToSearch() : null;
                      // goToSearch();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Search",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _on_change_validate() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      setState(() {
        checkTextController();
      });
    });
  }

  // goToSource() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const RentSource(type: '',)),
  //   );
  // }

  clearRoute() {
    viaList = [];
    sourcePlace.text = '';
    destinationPlace.text = '';
    startDateInput..text = '';
    tripEndDate.text = '';
    viaPlace.text = '';
    isCheckController = false;
  }

  checkTextController() async {
    if (sourcePlace.text.isNotEmpty &&
        destinationPlace.text.isNotEmpty &&
        viaPlace.text.isNotEmpty &&
        startDateInput.text.isNotEmpty &&
        tripEndDate.text.isNotEmpty && tripType == '72') {
      isCheckController = true;
    }else if(sourcePlace.text.isNotEmpty &&
        viaPlace.text.isNotEmpty &&
        startDateInput.text.isNotEmpty &&
        tripEndDate.text.isNotEmpty && tripType == '73'){
      isCheckController = true;
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    print("${15986 * asin(sqrt(a))}");
    return 12742 * asin(sqrt(a));
  }

  makeLatLong() {
    List latLongList = [];

    for (int i = 0; i < 1; i++) {
      latLongList.add({"lat": source['lat'], "lng": source['lang']});
      if (viaList.isNotEmpty) {
        for (int j = 0; j < viaList.length; j++) {
          latLongList
              .add({"lat": viaList[j]['lat'], "lng": viaList[j]['lang']});
        }
      }
      latLongList.add({"lat": destination['lat'], "lng": destination['lang']});

      print("${latLongList.length}");
    }
    double totalDistance = 0;
    for (var l = 0; l < latLongList.length - 1; l++) {
      totalDistance += 1.3 *
          (calculateDistance(latLongList[l]["lat"], latLongList[l]["lng"],
              latLongList[l + 1]["lat"], latLongList[l + 1]["lng"]));
    }
    forwardDis = totalDistance;
    print("$totalDistance");
  }

  makeRetLatLong() {
    List latLongList = [];

    for (int i = 0; i < 1; i++) {
      latLongList.add({"lat": source['lat'], "lng": source['lang']});
      if (viaList.isNotEmpty) {
        for (int j = 0; j < viaList.length; j++) {
          latLongList
              .add({"lat": viaList[j]['lat'], "lng": viaList[j]['lang']});
        }
      }
      latLongList.add({"lat": source['lat'], "lng": source['lang']});

      print("${latLongList.length}");
    }
    double totalDistance = 0;
    for (var l = 0; l < latLongList.length - 1; l++) {
      totalDistance += 1.3 *
          (calculateDistance(latLongList[l]["lat"], latLongList[l]["lng"],
              latLongList[l + 1]["lat"], latLongList[l + 1]["lng"]));
    }
    forwardDis = totalDistance;
    print("$totalDistance");
  }

  getTripType() async {
    Map<String, dynamic> params = {};
    params['codeType'] = "return_type_cd";
    var result = (await apiService?.get("8052", "/api/get_enum_names", params));
    returnTypeList = result['data'];
    print("$returnTypeList");
    setState(() {});
  }

  goToSearch() async {
    Map<String, dynamic> body = {};
    List rentDataList = [];
    var trip = {};
    trip['tripStartingDate'] = startDateInput.text;
    trip['tripEndDate'] = tripEndDate.text;
    trip['tripSource'] = source;
    trip['tripDestination'] = destination;
    trip['tripVia'] = viaList;
    trip['isSameRoute'] = isReturnTrip;
    trip['returnTypeCd'] = tripType;
    trip['totalKm'] = forwardDis;
    trip['customerSno'] = user['appUserSno'];
    trip['sourceLocation'] = sourceLocation;
    trip['destinationLocation'] = destinationLocation;
    trip['viaList'] = viaList;
    if (tripType == '73') {
      rentDataList.add(trip);
      print("$rentDataList");
      if (isReturnTrip) {
        var data = {};
        data['tripStartingDate'] = startDateInput.text;
        data['tripEndDate'] = tripEndDate.text;
        data['tripSource'] = destination;
        data['tripDestination'] = returnDestination;
        data['tripVia'] = returnViaList;
        data['isSameRoute'] = isReturnTrip;
        data['returnTypeCd'] = tripType;
        data['totalKm'] = forwardDis;
        data['customerSno'] = user['appUserSno'];
        data['sourceLocation'] = sourceLocation;
        data['destinationLocation'] = destinationLocation;
        data['returnDestLocation'] = returnDestLocation;
        data['viaList'] = viaList;
        rentDataList.add(data);
      } else {
        var data = {};
        data['tripStartingDate'] = startDateInput.text;
        data['tripEndDate'] = tripEndDate.text;
        data['tripSource'] = destination;
        data['tripDestination'] = source;
        data['tripVia'] = viaList;
        data['isSameRoute'] = isReturnTrip;
        data['returnTypeCd'] = tripType;
        data['totalKm'] = forwardDis;
        data['customerSno'] = user['appUserSno'];
        data['sourceLocation'] = sourceLocation;
        data['destinationLocation'] = destinationLocation;
        data['returnDestLocation'] = returnDestLocation;
        data['viaList'] = viaList;
        rentDataList.add(data);
      }
    } else if (tripType == '72') {
      rentDataList.add(trip);
    }
    body['data'] = rentDataList;
    print("$body");

    var result = (await apiService?.post("8058", "/api/insert_rent_bus", body));
    print("$result");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RentBusList(body['data'])),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure want to return via same route?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: <Widget>[
        //   Text(""),
        // ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // isReturnTrip = false;
            Navigator.of(context).pop();
          },
          child: const Text('Yes', style: TextStyle(color: success)),
        ),
        TextButton(
          onPressed: () {
            isReturnTrip = true;
            returnSource = destination;
            returnSourcePlace.text = destinationPlace.text;
            print("$isReturnTrip");
            setState(() {});
            Navigator.of(context).pop();
          },
          child: const Text('No', style: TextStyle(color: danger)),
        ),
      ],
    );
  }
}
