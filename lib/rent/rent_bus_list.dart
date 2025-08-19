import 'package:flutter/material.dart';
import 'package:user/color/colors.dart';
import 'package:user/service/apiservice/apiservice.dart';
import 'package:intl/intl.dart';

import '../search bus/view_vehicle_dtl.dart';

class RentBusList extends StatefulWidget {
  final tripDtl;

  const RentBusList(this.tripDtl, {Key? key}) : super(key: key);

  @override
  State<RentBusList> createState() => _RentBusListState();
}

class _RentBusListState extends State<RentBusList> {
  ApiService apiService = ApiService();
  late List busList = [];
  late List busData = [];
  String? value;
  bool isSwitched = false;
  late List via = [];
  String? displayText;


  // String _getShortenedLocation(String location) {
  //   // Split the address by commas
  //   List<String> parts = location.split(',');
  //
  //   // Extract the relevant parts, for example, the first two parts
  //   // Assuming the format is "locality, city, state, country, zip"
  //   if (parts.length >= 2) {
  //     // Trim and clean up any unwanted characters from the parts
  //     String locality = parts[0].trim();
  //     return "$locality"; // locality, city
  //   } else {
  //     return location.trim(); // Return the full location if splitting is not possible
  //   }
  // }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("wigetData${widget.tripDtl}");
    print("wigetData${widget.tripDtl[0]['isSameRoute']}");
    // via = widget.tripDtl[0]['viaList'];
    // print(via[0]['place']);

    via = widget.tripDtl[0]['viaList'];
    print(via[0]['place']);
    // List<String> places = via.map((via) => via['place'].toString()).toList();
    List<String> places = via.map((via) {
      // Split the place string and take the first part (the city name)
      return via['place'].toString().split(',')[0].trim();
    }).toList();
    print(places);
    displayText = places.join(' -> ');
    getContactCarrage();
  }

  List<TextSpan> _buildTextSpan(String displayText) {
    List<TextSpan> textSpans = [];
    List<String> places = displayText.split('->');
    for (int i = 0; i < places.length; i++) {
      textSpans.add(TextSpan(
        text: places[i].trim(),
        style: TextStyle(
            decoration: TextDecoration.none,
          color: Colors.red, // Customize the color as needed
          // fontWeight: FontWeight.bold,
          fontSize: 12.0
        ),
      ));
      if (i < places.length - 1) {
        textSpans.add(TextSpan(
          text: ' -> ',
          style: TextStyle(
              decoration: TextDecoration.none,
            color: Colors.black, // Customize the color as needed
            // fontWeight: FontWeight.bold,
              fontSize: 12.0
          ),
        ));
      }
    }
    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: white, //change your color here
        ),
        backgroundColor: primary,
        title: const Text("Rent Detail", style: TextStyle(color: white)),
      ),
      body: widget.tripDtl != null ? ListView(
        children: [
          Card(
            color: Colors.white,
            surfaceTintColor: white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.date_range_rounded,
                            size: 16,
                          )),
                          TextSpan(
                              text:
                                  ' ${widget.tripDtl[0]['tripStartingDate']} <--> ${widget.tripDtl[0]['tripEndDate']}',
                              style: TextStyle(color: success)),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 0.0),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    // title: Text(getDate()),
                    title: widget.tripDtl[0]['returnTypeCd'] == '72'
                        ? Text("One Way Trip , ${getDate()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14))
                        : Text("Rounded, ${getDate()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                    trailing: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.speed_outlined,
                            size: 16,
                            color: success,
                          )),
                          TextSpan(
                              text: " ${getTotalKm()} Km",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  // widget.tripDtl[0]['returnTypeCd'] == '72'?Padding(
                  //   padding: EdgeInsets.all(0.0),
                  //   child: Text(
                  //       // "${widget.tripDtl[0]['tripSource']['place'].substring(0, widget.tripDtl[0]['tripSource']['place'].indexOf(','))} <--> ${widget.tripDtl[0]['tripDestination']['place'].substring(0, widget.tripDtl[0]['tripDestination']['place'].indexOf(','))} ",
                  //     "${widget.tripDtl[0]['sourceLocation']} <--> ${widget.tripDtl[0]['destinationLocation']}",
                  //       style: TextStyle(color: secondary)),
                  // ):
                  // widget.tripDtl.length == 2
                  //     ? Padding(
                  //         padding: EdgeInsets.only(top: 8),
                  //         child: widget.tripDtl[0]['isSameRoute']? Column(
                  //           children: [
                  //             // Text("${widget.tripDtl[0]['sourceLocation']} <--> ${widget.tripDtl[0]['sourceLocation']}",
                  //             //     style: const TextStyle(color: secondary)),
                  //             // SizedBox(height: 10,),
                  //             // Text("${widget.tripDtl[1]['destinationLocation']} <--> ${widget.tripDtl[1]['returnDestLocation']}",
                  //             //     style: const TextStyle(color: secondary)),
                  //           ],
                  //         ):
                  //         Column(
                  //           children: [
                  //             Text("${widget.tripDtl[0]['sourceLocation']} <--> ${widget.tripDtl[0]['sourceLocation']}",
                  //                 style: const TextStyle(color: secondary)),
                  //             // SizedBox(height: 10,),
                  //             // Text("${widget.tripDtl[0]['destinationLocation']} <--> ${widget.tripDtl[0]['sourceLocation']}",
                  //             //     style: const TextStyle(color: secondary)),
                  //           ],
                  //         ),
                  //       )
                  //     : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.tripDtl[0]['returnTypeCd'] == '72'
                          ?    Expanded(
                  child: Text(
                    "${widget.tripDtl[0]['sourceLocation']} <--> ${widget.tripDtl[0]['destinationLocation']}",
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
      )
                          : Expanded(
                            child: Text(
                                "${widget.tripDtl[0]['sourceLocation']} <--> ${widget.tripDtl[0]['sourceLocation']}",
                                style: const TextStyle(color: secondary),overflow: TextOverflow.ellipsis, ),
                          ),
                      Row(
                        children: [
                          Text('Show Via:'),
                          Switch(
                            value: isSwitched,
                            activeColor: Colors.purple,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                print(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  isSwitched?Divider():Container(),
                  isSwitched?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    Image.asset(
                        'assets/images/via-route.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 20,),
                      // Expanded(child: Text("${displayText}", style: TextStyle(color: Colors.red, ),),)
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: _buildTextSpan(displayText!),
                          ),
                        ),
                      ),

                    ],
                  ):Container()
                ],
              ),
            ),
          ),
          busData.isEmpty
              ? Container(
                  child: Image.asset(
                    "assets/images/not_found.jpeg",
                    width: 300,
                    height: 300,
                  ),
                )
              : Container(),
          for (var bus in busData)
            // for (var bus in busList)
            Card(
              color: Colors.white,
              surfaceTintColor: white,
              child: Column(
                children: [
                  // ListTile(
                  //   title: Text("18/02/2023 - 20/02/2023"),
                  //   subtitle: Text("40 seats"),
                  //   trailing: Text("Booking"),
                  // ),
                  ListTile(
                      onTap: () {
                        print('BUSDETAILS${bus}');
                        print('VALUES$value');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewVehicleDtl(
                                  bus,
                                  (double.parse(value!) *
                                          (bus['pricePerDay'] / 400))
                                      .toStringAsFixed(2))),
                        );
                      },
                      leading: const Icon(Icons.bus_alert_rounded),
                      title: Text("${bus['vehicleName']}"),
                      subtitle: Row(
                        children: [
                          Text("${bus['coolType']} ,"),
                          bus['seatCapacity'] != null
                              ? Text("${bus['seatCapacity']} Seats")
                              : Text(" --- Seats")
                        ],
                      ),
                      trailing: bus['isBooked'] == 1
                          ? const Text(
                              "Booked",
                              style: TextStyle(
                                  color: danger, fontWeight: FontWeight.w500),
                            )
                          : const Text(
                              "Available",
                              style: TextStyle(
                                  color: success, fontWeight: FontWeight.w500),
                            )
                      // Text(
                      //     "₹ ${(double.parse(value!) * (bus['pricePerDay'] / 400)).toStringAsFixed(2)}"),
                      ),
                ],
              ),
            )
        ],
      ) : Container(),
    );
  }

  // getContactCarrage() async {
  //   DateTime date1 = new DateFormat("yyyy-MM-dd")
  //       .parse(widget.tripDtl[0]['tripStartingDate']);
  //   DateTime date2 = new DateFormat("yyyy-MM-dd")
  //       .parse(widget.tripDtl[0]['tripEndDate']);
  //   print('date1$date1');
  //   print('date2$date2');
  //   Map<String, dynamic> params = {};
  //   params['startDate']=date1;
  //   params['endDate']=date2;
  //   var result =
  //   (await apiService?.get("8058", "/api/get_contact_carrage", params));
  //   print("padhu$result");
  //   busList = result['data'];
  //   setState(() {});
  // }

  // getTotalKm() {
  //   double total = 0;
  //   for (var data in widget.tripDtl) {
  //     total = total + data['totalKm'];
  //     value = total.toStringAsFixed(2);
  //     return value;
  //   }
  // }

  getDate() {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date1 = inputFormat.parse(widget.tripDtl[0]['tripStartingDate']);
    var date2 = inputFormat.parse(widget.tripDtl[0]['tripEndDate']);
    var outputFormat = DateFormat('yyyy-MM-dd');
    DateTime date3 = DateTime.parse(outputFormat.format(date1));
    DateTime date4 = DateTime.parse(outputFormat.format(date2));
    return "${date4.difference(date3).inDays} days";
  }

  getContactCarrage() async {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var tripStartingDate =
        inputFormat.parse(widget.tripDtl[0]['tripStartingDate']);
    var tripEndDate = inputFormat.parse(widget.tripDtl[0]['tripEndDate']);
    var outputFormat = DateFormat('yyyy-MM-dd');
    DateTime startDate = DateTime.parse(outputFormat.format(tripStartingDate));
    DateTime endDate = DateTime.parse(outputFormat.format(tripEndDate));
    Map<String, dynamic> params = {};
    params['startDate'] = startDate;
    params['endDate'] = endDate;
    print('PARAMS$params');
    var result =
        (await apiService?.get("8058", "/api/get_contact_carrage", params));
    print("padhujds$result");
    busList = result['data'];
    for (var bus in busList) {
      if (bus['districtName'] == widget.tripDtl[0]['sourceLocation'] &&
          bus['isBooked'] == 0) {
        print('newBus$bus');
        busData.add(bus);
        print('FinalResult$busData');
      }
    }
    setState(() {});
  }

  getTotalKm() {
    double total = 0;
    // double percentage = 0;
    for (var data in widget.tripDtl) {
      if (data['returnTypeCd'] == '72') {
        print('${data['returnTypeCd']}');
        // percentage = percentage + data['totalKm'] * 0.05;
        total = total + data['totalKm'];
      } else {
        if (data['isSameRoute'] == false) {
          print('isSameRoute${data['isSameRoute']}');
          // percentage = percentage + data['totalKm'] * 0.05;
          total = total + data['totalKm'];
        } else {
          var data = widget.tripDtl[1];
          print('isSameRoute${data['isSameRoute']}');
          total = total + data['totalKm'];
        }
      }
      value = total.toStringAsFixed(2);
      return value;
    }
  }
}
