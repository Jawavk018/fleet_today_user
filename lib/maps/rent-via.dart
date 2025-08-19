import 'dart:async';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../color/colors.dart';

class RentViaMap extends StatefulWidget {
  final source;
  final destination;
  final via;
  final type;
  // final returnDes;
  final returnvia;
  final tripType;

  // const RentViaMap(this.source, this.destination, {this.via, this.type, this.returnDes, this.returnvia});
  const RentViaMap(
    this.source,
    this.destination, {
    this.via,
    this.type,
    this.returnvia,
    this.tripType,
  });
  @override
  State<RentViaMap> createState() => _RentViaMapState();
}

class _RentViaMapState extends State<RentViaMap> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? sourceLocation;
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];
  String googleApikey = "AIzaSyAIlF9Gq02HuzE64jX_U0E3FcIs_TZsNJM";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  List? viaList = [];
  List? returnViaList = [];
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  String location = "Search Location";
  late LocationData data;
  List<Marker> markersList = <Marker>[];
  var locationData;
  var returnDestination;

  List? removeViaList = [];
  List? removeReturnViaList = [];
  String sourceString = '';
  String destinationString = '';
  String returnDestinationString = '';
  String alphabet = '';
  var trip = {};

  @override
  void initState() {
    print('TRIPTYPE${widget.tripType}');

    if (widget.via != null) {
      viaList = widget.via;
      print('VIALIST$viaList');
    }
    if (widget.returnvia != null) {
      returnViaList = widget.returnvia;
      print('RETYRNLIST$returnViaList');
    }
    // if (widget.returnDes != null) {
    //   returnDestination = widget.returnDes;
    // }
    if (widget.source != null) {
      sourceLocation = LatLng(widget.source['lat'], widget.source['lang']);
      print('SOURCE${widget.source}');
    }
    if (widget.destination != null) {
      destination =
          LatLng(widget.destination['lat'], widget.destination['lang']);
      print('DEST${widget.destination}');
    }

    if (widget.tripType == '72') {
      setMarkers();
    } else {
      setRoundTripMarker();
    }

    super.initState();

    splitString();
    setViaList();
  }

  setViaList() {
    if (widget.type == 'via') {
      for (int i = 0; i < viaList!.length; i++) {
        String inputString = viaList![i]['place'];
        List<String> parts = inputString.split(',');
        alphabet = String.fromCharCode(66 + i);
        print(alphabet); // A=65, B=66, C=67, etc.
        String place = parts[0].trim();
        String alpha = alphabet;
        trip['viaLocation'] = place;
        trip['index'] = alpha;
        removeViaList!.add(trip);
        print('$removeViaList');
        trip = {};
      }
    } else {
      for (int i = 0; i < returnViaList!.length; i++) {
        String inputString = returnViaList![i]['place'];
        List<String> parts = inputString.split(',');
        alphabet = String.fromCharCode(66 + i);
        print(alphabet); // A=65, B=66, C=67, etc.
        String place = parts[0].trim();
        String alpha = alphabet;
        trip['viaLocation'] = place;
        trip['index'] = alpha;
        removeViaList!.add(trip);
        trip = {};
      }
    }
  }

  splitString() {
    sourceString = widget.source['place'];
    print('sourceString$sourceString');
    print('sourceString${widget.destination}');
    if (widget.destination != null) {
      destinationString = widget.destination['place'];
      List<String> parts = destinationString.split(',').map((part) => part.trim()).where((part) => part.isNotEmpty).toList();
      destinationString = parts.join(', ');
    }
    List<String> parts = sourceString.split(',').map((part) => part.trim()).where((part) => part.isNotEmpty).toList();
    sourceString = parts.join(', ');
  }

  // splitString() {
  //   sourceString = widget.source['place'];
  //   destinationString = widget.destination['place'];
  //   List<String> parts = sourceString.split(',');
  //   String result1 = parts[0].trim();
  //   sourceString = result1;
  //   List<String> part = destinationString.split(',');
  //   String result2 = part[0].trim();
  //   destinationString = result2;
  //
  //   if (returnDestination != null) {
  //     print("${returnDestination['place']}");
  //     returnDestinationString = returnDestination['place'];
  //     List<String> parts = returnDestinationString.split(',');
  //     String result1 = parts[0].trim();
  //     returnDestinationString = result1;
  //     print('$returnDestinationString');
  //
  //   }
  // }

  // setMarkers() async {
  //   Marker _source = Marker(
  //     markerId: MarkerId("source"),
  //     position: sourceLocation as LatLng,
  //     infoWindow: InfoWindow(title: "source"),
  //   );
  //   markersList.add(_source);
  //
  //   if ((viaList!.isNotEmpty && widget.type == 'via') || (viaList!.isNotEmpty && widget.type == 'returnVia')) {
  //     for (int i = 0; i < viaList!.length; i++) {
  //       Marker via = Marker(
  //         markerId: MarkerId("via$i"),
  //         icon: await BitmapDescriptor.fromAssetImage(
  //             ImageConfiguration(size: Size(12, 12)), 'assets/images/pin.png'),
  //         position: LatLng(viaList![i]['lat'], viaList![i]['lang']),
  //         infoWindow: InfoWindow(title: "via$i"),
  //       );
  //       markersList.add(via);
  //     }
  //     print("$markersList");
  //     // print("markerID markerId");
  //     setState(() {});
  //   }
  //   Marker _distination = Marker(
  //     markerId: MarkerId("distination"),
  //     position: destination as LatLng,
  //     infoWindow: InfoWindow(title: "distination"),
  //   );
  //   markersList.add(_distination);
  //
  //   if (returnViaList!.isNotEmpty && widget.type == 'returnVia') {
  //     for (int i = 0; i < returnViaList!.length; i++) {
  //       Marker returnVia = Marker(
  //         markerId: MarkerId("return via$i"),
  //         position: LatLng(returnViaList![i]['lat'], returnViaList![i]['lang']),
  //         icon: await BitmapDescriptor.fromAssetImage(
  //             ImageConfiguration(size: Size(12, 12)), 'assets/images/car.png'),
  //         infoWindow: InfoWindow(title: "return via$i"),
  //       );
  //       markersList.add(returnVia);
  //     }
  //     print("$markersList");
  //     setState(() {});
  //   }
  //   if (returnDestination != null) {
  //     Marker _returnDestination = Marker(
  //       markerId: const MarkerId("returnDestination"),
  //       position: LatLng(returnDestination['lat'], returnDestination['lang']),
  //       infoWindow: const InfoWindow(title: "returnDestination"),
  //     );
  //     markersList.add(_returnDestination);
  //
  //     print("$markersList");
  //   }
  //   getPolyPoints();
  // }

  setMarkers() async {
    Marker _source = Marker(
      markerId: MarkerId("source"),
      position: sourceLocation as LatLng,
      infoWindow: InfoWindow(title: "source"),
    );
    markersList.add(_source);

    if ((viaList!.isNotEmpty &&
        widget.type == 'via' &&
        widget.tripType == '72')) {
      for (int i = 0; i < viaList!.length; i++) {
        Marker via = Marker(
          markerId: MarkerId("via$i"),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(12, 12)), 'assets/images/pin.png'),
          position: LatLng(viaList![i]['lat'], viaList![i]['lang']),
          infoWindow: InfoWindow(title: "via$i"),
        );
        markersList.add(via);
      }
      print("$markersList");
      // print("markerID markerId");
      setState(() {});
    }
    Marker _distination = Marker(
      markerId: MarkerId("distination"),
      position: destination as LatLng,
      infoWindow: InfoWindow(title: "distination"),
    );
    markersList.add(_distination);
    getPolyPoints();
  }

  setRoundTripMarker() async {
    Marker _source = Marker(
      markerId: MarkerId("source"),
      position: sourceLocation as LatLng,
      infoWindow: InfoWindow(title: "source"),
    );
    markersList.add(_source);

    if ((viaList!.isNotEmpty &&
        widget.type == 'via' &&
        widget.tripType == '73')) {
      for (int i = 0; i < viaList!.length; i++) {
        Marker via = Marker(
          markerId: MarkerId("via$i"),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(12, 12)), 'assets/images/car.png'),
          position: LatLng(viaList![i]['lat'], viaList![i]['lang']),
          infoWindow: InfoWindow(title: "via$i"),
        );
        markersList.add(via);
      }
      print("$markersList");
      // print("markerID markerId");
      setState(() {});
    }
    // Marker _distination = Marker(
    //   markerId: MarkerId("distination"),
    //   position: destination as LatLng,
    //   infoWindow: InfoWindow(title: "distination"),
    // );
    // markersList.add(_distination);
    getRoundTripPolyPoints();
  }

  void getPolyPoints() async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAIlF9Gq02HuzE64jX_U0E3FcIs_TZsNJM", // Your Google Map Key
      PointLatLng(widget.source['lat'], widget.source['lang']),
      // PointLatLng(viaList![0]['lat'], viaList![0]['lang']),
      PointLatLng(widget.destination['lat'], widget.destination['lang']),
    );
    if (viaList!.isNotEmpty) {
      result.points = [];

      if (viaList!.isNotEmpty) {
        result.points.add(
          PointLatLng(widget.source['lat'], widget.source['lang']),
        );
        for (int i = 0; i < viaList!.length; i++) {
          result.points.add(
            PointLatLng(viaList![i]['lat'], viaList![i]['lang']),
          );
        }
        result.points.add(
          PointLatLng(widget.destination['lat'], widget.destination['lang']),
        );
      }
    }
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(
        LatLng(point.latitude, point.longitude),
      );
    });
    print("$polylineCoordinates");
    setState(() {});
  }

  // void _addPolyline() {
  //   _polylines.add(Polyline(
  //     polylineId: PolylineId("your_polyline_id"),
  //     color: Colors.blue, // Set your desired color here
  //     width: 5, // Set your desired width here
  //     points: _polylineCoordinates,
  //   ));
  // }

  void getRoundTripPolyPoints() async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAIlF9Gq02HuzE64jX_U0E3FcIs_TZsNJM", // Your Google Map Key
      PointLatLng(widget.source['lat'], widget.source['lang']),
      // PointLatLng(viaList![0]['lat'], viaList![0]['lang']),
      PointLatLng(widget.source['lat'], widget.source['lang']),
    );
    if (viaList!.isNotEmpty) {
      result.points = [];

      if (viaList!.isNotEmpty) {
        result.points.add(
          PointLatLng(widget.source['lat'], widget.source['lang']),
        );
        for (int i = 0; i < viaList!.length; i++) {
          result.points.add(
            PointLatLng(viaList![i]['lat'], viaList![i]['lang']),
          );
        }
        result.points.add(
          PointLatLng(widget.source['lat'], widget.source['lang']),
        );
      }
    }
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(
        LatLng(point.latitude, point.longitude),
      );
    });
    print("$polylineCoordinates");
    setState(() {});
  }

  splitViaListString() {
    removeViaList!.clear();
    if (widget.type == 'via') {
      for (int i = 0; i < viaList!.length; i++) {
        String inputString = viaList![i]['place'];
        List<String> parts = inputString.split(',');
        alphabet = String.fromCharCode(66 + i);
        print(alphabet); // A=65, B=66, C=67, etc.
        String place = parts[0].trim();
        String alpha = alphabet;
        trip['viaLocation'] = place;
        trip['index'] = alpha;
        removeViaList!.add(trip);
        print('$removeViaList');
        trip = {};
      }
    } else {
      for (int i = 0; i < returnViaList!.length; i++) {
        String inputString = returnViaList![i]['place'];
        List<String> parts = inputString.split(',');
        alphabet = String.fromCharCode(66 + i);
        print(alphabet); // A=65, B=66, C=67, etc.
        String place = parts[0].trim();
        String alpha = alphabet;
        trip['viaLocation'] = place;
        trip['index'] = alpha;
        removeViaList!.add(trip);
        trip = {};
      }
    }
  }

  void removeItem(int index) {
    setState(() {
      viaList!.removeAt(index);
    });
  }

  // Function to remove a specific set of polyline coordinates
  void removePolylineCoordinates(LatLng position) {
    setState(() {
      polylineCoordinates.removeWhere((coordinate) {
        return coordinate == position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("$context");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            body: sourceLocation == null
                ? const Center(child: Text("Loading"))
                : Stack(children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(sourceLocation!.latitude!,
                            sourceLocation!.longitude!),
                        zoom: 6,
                      ),
                      markers: Set<Marker>.of(markersList),
                      onMapCreated: (controller) {
                        //method called when map is created
                        print(controller);
                        setState(() {
                          mapController = controller;
                        });
                      },
                      onCameraMove: (CameraPosition cameraPositiona) {
                        cameraPosition = cameraPositiona; //when map is dragging
                      },
                      polylines: {
                        widget.tripType == '72'
                            ? Polyline(
                                polylineId: const PolylineId("route"),
                                points: polylineCoordinates,
                                color: const Color(0xFF6186FF),
                                width: 5,
                              )
                            : Polyline(
                                polylineId: const PolylineId("route"),
                                points: polylineCoordinates,
                                color: const Color(0xFF21b506),
                                width: 5,
                              ),
                      },
                    ),
                    widget.type == 'returnDestination'
                        ? Positioned(
                            //search input bar
                            top: 10,
                            child: InkWell(
                                onTap: () async {
                                  var place = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleApikey,
                                      mode: Mode.overlay,
                                      types: [],
                                      strictbounds: false,
                                      components: [
                                        Component(Component.country, 'in')
                                      ],
                                      //google_map_webservice package
                                      onError: (err) {
                                        print(err);
                                      });

                                  if (place != null) {
                                    setState(() {
                                      location = place.description.toString();
                                    });

                                    //form google_maps_webservice package
                                    final plist = GoogleMapsPlaces(
                                      apiKey: googleApikey,
                                      apiHeaders:
                                          await GoogleApiHeaders().getHeaders(),
                                      //from google_api_headers package
                                    );
                                    String placeid = place.placeId ?? "0";
                                    final detail = await plist
                                        .getDetailsByPlaceId(placeid);
                                    final geometry = detail.result.geometry!;
                                    final lat = geometry.location.lat;
                                    final lang = geometry.location.lng;
                                    var newlatlang = LatLng(lat, lang);
                                    Map<String, dynamic> data = {};
                                    data['lat'] = lat;
                                    data['lang'] = lang;
                                    data['place'] = place.description;
                                    locationData = data;
                                    print("locationData $locationData");
                                    if (widget.type == 'via') {
                                      viaList?.add(data);
                                    } else if (widget.type ==
                                        'returnDestination') {
                                      returnDestination = data;
                                    } else {
                                      returnViaList?.add(data);
                                    }
                                    setMarkers();
                                    print("viaList $viaList");
                                    setState(() {});
                                    //move map camera to selected place with animation
                                    mapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: newlatlang, zoom: 6)));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Card(
                                    color: Colors.white,
                                    surfaceTintColor: white,
                                    child: Container(
                                        padding: EdgeInsets.all(0),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: ListTile(
                                          title: Text(
                                            location,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          trailing: Icon(Icons.search),
                                          dense: true,
                                        )),
                                  ),
                                )))
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 15.0, right: 15.0),
                            child: Card(
                                color: Colors.white,
                                surfaceTintColor: white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  height: 170,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    reverse: true,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: widget.tripType == '72'
                                              ? Text('${sourceString}')
                                              : Text('${sourceString}'),
                                          leading: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Icon(
                                              Icons.radio_button_checked,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          trailing: SizedBox(
                                            width: 80,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/road.png',
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.fill,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0),
                                                  child: Icon(Icons.clear),
                                                )
                                              ],
                                            ),
                                          ),
                                          visualDensity:
                                              VisualDensity(vertical: -4),
                                          // isThreeLine: true,
                                        ),
                                        // Divider(indent: 50, endIndent: 50),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: MyCustomWidget(),
                                        ),
                                        ListTile(
                                          title: widget.tripType == '72'
                                              ? Text('${destinationString}')
                                              : Text('${sourceString}'),
                                          leading: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  shape: BoxShape.circle),
                                              child: Text(
                                                'A',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          trailing: SizedBox(
                                            width: 80,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/road.png',
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.fill,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0),
                                                  child: Icon(Icons.clear),
                                                )
                                              ],
                                            ),
                                          ),
                                          visualDensity:
                                              VisualDensity(vertical: -4),
                                        ),
                                        // Divider(indent: 50, endIndent: 50),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: MyCustomWidget(),
                                        ),
                                        for (int i = 0;
                                            i < removeViaList!.length;
                                            i++)
                                          Container(
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                      '${removeViaList![i]['viaLocation']}'),
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                            shape: BoxShape
                                                                .circle),
                                                        child: Text(
                                                          '${removeViaList![i]['index']}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        )),
                                                  ),
                                                  trailing: SizedBox(
                                                    width: 80,
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/road.png',
                                                          width: 20,
                                                          height: 20,
                                                          fit: BoxFit.fill,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (widget.type ==
                                                                  'via') {
                                                                removeViaList!
                                                                    .removeAt(
                                                                        i);
                                                                setState(() {
                                                                  markersList.removeWhere((marker) =>
                                                                      marker
                                                                          .markerId
                                                                          .value ==
                                                                      "via$i");
                                                                  removePolylineCoordinates(LatLng(
                                                                      viaList![
                                                                              i]
                                                                          [
                                                                          'lat'],
                                                                      viaList![
                                                                              i]
                                                                          [
                                                                          'lang']));
                                                                  viaList!
                                                                      .removeAt(
                                                                          i);
                                                                });
                                                              } else {
                                                                removeViaList!
                                                                    .removeAt(
                                                                        i);
                                                                setState(() {
                                                                  markersList.removeWhere((marker) =>
                                                                      marker
                                                                          .markerId
                                                                          .value ==
                                                                      "return via$i");
                                                                  removePolylineCoordinates(LatLng(
                                                                      returnViaList![
                                                                              i]
                                                                          [
                                                                          'lat'],
                                                                      returnViaList![
                                                                              i]
                                                                          [
                                                                          'lang']));
                                                                  returnViaList!
                                                                      .removeAt(
                                                                          i);
                                                                });
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.clear),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  visualDensity: VisualDensity(
                                                      vertical: -4),
                                                ),
                                                // Divider(indent: 50, endIndent: 50),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, right: 15),
                                                  child: MyCustomWidget(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Container(
                                          child: ListTile(
                                            title: InkWell(
                                              onTap: () async {
                                                var place = await PlacesAutocomplete
                                                    .show(
                                                        context: context,
                                                        apiKey: googleApikey,
                                                        mode: Mode.overlay,
                                                        types: [],
                                                        strictbounds: false,
                                                        components: [
                                                          Component(
                                                              Component.country,
                                                              'in')
                                                        ],
                                                        //google_map_webservice package
                                                        onError: (err) {
                                                          print(err);
                                                        });

                                                if (place != null) {
                                                  setState(() {
                                                    location = place.description
                                                        .toString();
                                                  });

                                                  //form google_maps_webservice package
                                                  final plist =
                                                      GoogleMapsPlaces(
                                                    apiKey: googleApikey,
                                                    apiHeaders:
                                                        await GoogleApiHeaders()
                                                            .getHeaders(),
                                                    //from google_api_headers package
                                                  );
                                                  String placeid =
                                                      place.placeId ?? "0";
                                                  final detail = await plist
                                                      .getDetailsByPlaceId(
                                                          placeid);
                                                  final geometry =
                                                      detail.result.geometry!;
                                                  final lat =
                                                      geometry.location.lat;
                                                  final lang =
                                                      geometry.location.lng;
                                                  var newlatlang =
                                                      LatLng(lat, lang);
                                                  Map<String, dynamic> data =
                                                      {};
                                                  data['lat'] = lat;
                                                  data['lang'] = lang;
                                                  data['place'] =
                                                      place.description;
                                                  locationData = data;
                                                  print(
                                                      "locationData $locationData");
                                                  if (widget.type == 'via') {
                                                    viaList?.add(data);
                                                  } else if (widget.type ==
                                                      'returnDestination') {
                                                    returnDestination = data;
                                                  } else {
                                                    returnViaList?.add(data);
                                                  }
                                                  widget.tripType == '72'
                                                      ? setMarkers()
                                                      : setRoundTripMarker();
                                                  splitViaListString();
                                                  print("viaList $viaList");
                                                  setState(() {});
                                                  //move map camera to selected place with animation
                                                  mapController?.animateCamera(
                                                      CameraUpdate
                                                          .newCameraPosition(
                                                              CameraPosition(
                                                                  target:
                                                                      newlatlang,
                                                                  zoom: 6)));
                                                }
                                              },
                                              child: Text(
                                                'Choose Via',
                                                style:
                                                    TextStyle(color: secondary),
                                              ),
                                            ),
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.red,
                                              ),
                                            ),
                                            trailing: SizedBox(
                                              width: 80,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/road.png',
                                                    width: 20,
                                                    height: 20,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            visualDensity:
                                                VisualDensity(vertical: -4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                  ]),
            floatingActionButton: FloatingActionButton(
              backgroundColor: primary,
              child: const Icon(Icons.check),
              onPressed: () {
                if (widget.type == 'via') {
                  Navigator.pop(context, viaList);
                } else if (widget.type == 'returnDestination') {
                  Navigator.pop(context, returnDestination);
                } else if (widget.type == 'returnVia') {
                  Navigator.pop(context, returnViaList);
                }
                // Add your onPressed code here!
              },
            ),
          ),
        ));
  }
}

class MyCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.blue,
    //   padding: EdgeInsets.all(16),
    //   child: Text('Custom Widget Content'),
    // );
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            children: [
              Container(
                width: 3, // Adjust the size of the dots as needed
                height: 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black45, // Dot color
                ),
              ),
              SizedBox(height: 3),
              Container(
                width: 3, // Adjust the size of the dots as needed
                height: 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black45, // Dot color
                ),
              ),
              SizedBox(
                  height: 3), // Adjust the space between the dots and the line
              Container(
                width: 3, // Adjust the size of the dots as needed
                height: 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black45, // Dot color
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 1,
          color: Colors.black12,
        ),
      ],
    );
  }
}
