import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../color/colors.dart';

class RentSource extends StatefulWidget {
  final type;
  // const RentSource({Key? key}) : super(key: key);
  const RentSource({this.type});


  @override
  State<RentSource> createState() => _RentSourceState();
}

class _RentSourceState extends State<RentSource> {
  String googleApikey = "AIzaSyAIlF9Gq02HuzE64jX_U0E3FcIs_TZsNJM";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = const LatLng(27.6602292, 85.308027);

  String locationValue = "";

  String location = "";
  var locationData;
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
    print("TYPE: ${widget.type}");

  }


  // getLocation() async {
  //   LocationPermission permission;
  //   permission = await Geolocator.requestPermission();
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   double lat = position.latitude;
  //   double long = position.longitude;
  //   LatLng location = LatLng(lat, long);
  //   setState(() {
  //     _currentPosition = location;
  //     _isLoading = false;
  //   });
  // }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    LatLng location = LatLng(lat, long);

    List<Placemark> destinationPlace =
    await placemarkFromCoordinates(lat, long);
    Placemark placeMark = destinationPlace[0];
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;

    setState(() {
      if (widget.type == 'source' && locationData == null) {
        locationValue = "$subLocality, $locality";
        Map<String, dynamic> data = {};
        data['lat'] = position.latitude;
        data['lang'] = position.longitude;
        data['place'] = locationValue;
        locationData = data;
      }
      _currentPosition = location;
      _isLoading = false;
    });
  }


  getLocationFromCoordinates(LatLng coordinates) async {
    double lat = coordinates.latitude;
    double long = coordinates.longitude;
    List<Placemark> destinationPlace = await placemarkFromCoordinates(lat, long);
    Placemark placeMark = destinationPlace[0];

    String? subLocality = placeMark.subLocality;
    if (subLocality != null && subLocality.isNotEmpty) {
      setState(() {
        location = subLocality;
        Map<String, dynamic> data = {};
        data['lat'] = lat;
        data['lang'] = long;
        data['place'] = subLocality;
        locationData = data;
      });
    } else {
      // Handle the case when sublocality is not available
      // You can set a default value or display a message
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_currentPosition!=null? Stack(children: [
        GoogleMap(
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _currentPosition!,
            zoom: 14.0,
          ),
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
          onCameraMove: (CameraPosition cameraPosition) {
            this.cameraPosition = cameraPosition;
          },
          onCameraIdle: () async {
            if (cameraPosition != null) {
              await getLocationFromCoordinates(cameraPosition!.target);
            }
          },
          // //Map widget from google_maps_flutter package
          // zoomGesturesEnabled: true,
          // //enable Zoom in, out on map
          // initialCameraPosition: CameraPosition(
          //   //innital position in map
          //   // target: _currentPosition!, //initial position
          //   target: widget.type != 'source' ? LatLng(widget.type['lat'],widget.type['lang']) : _currentPosition!,
          //   zoom: 14.0, //initial zoom level
          // ),
          // mapType: MapType.normal,
          // //map type
          // onMapCreated: (controller) {//method called when map is created
          //   setState(() {
          //     mapController = controller;
          //   });
          // },
          //
          // onCameraMove: (CameraPosition cameraPosition) {
          //   // You don't need to assign to cameraPosition here.
          //   // cameraPosition = cameraPosition;
          //   print("muthu$_currentPosition");
          // },
          //
          // onCameraIdle: () async {
          //   final cameraPosition = this.cameraPosition;
          //   if (cameraPosition != null) { // Check if cameraPosition is not null
          //     print("4544545$cameraPosition");
          //
          //     List<Placemark> placemarks = await placemarkFromCoordinates(
          //       cameraPosition.target.latitude,
          //       cameraPosition.target.longitude,
          //     );
          //
          //     setState(() {
          //       location = placemarks.first.administrativeArea.toString() +
          //           ", " +
          //           placemarks.first.street.toString();
          //       Map<String, dynamic> data = {};
          //       data['lat'] = cameraPosition.target.latitude;
          //       data['lang'] = cameraPosition.target.longitude;
          //       data['place'] = location;
          //       locationData = data;
          //       print("jhjdh$locationData");
          //     });
          //   }
          // },
        ),
        Center(
          //picker image on google map
          child: Image.asset(
            "assets/images/picker.png",
            width: 80,
          ),
        ),
        // Positioned(  //widget to display location name
        //     bottom:100,
        //     child: Padding(
        //       padding: EdgeInsets.all(15),
        //       child: Card(
        //         child: Container(
        //             padding: EdgeInsets.all(0),
        //             width: MediaQuery.of(context).size.width - 40,
        //             child: ListTile(
        //               leading: Image.asset("assets/images/picker.png", width: 25,),
        //               title:Text(location, style: TextStyle(fontSize: 18),),
        //               dense: true,
        //             )
        //         ),
        //       ),
        //     )
        // ),

        //search autoconplete input
        Positioned(
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
                      components: [Component(Component.country, 'in')],
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
                      apiHeaders: await GoogleApiHeaders().getHeaders(),
                      //from google_api_headers package
                    );
                    String placeid = place.placeId ?? "0";
                    final detail = await plist.getDetailsByPlaceId(placeid);
                    final geometry = detail.result.geometry!;
                    final lat = geometry.location.lat;
                    final lang = geometry.location.lng;
                    var newlatlang = LatLng(lat, lang);
                    Map<String,dynamic> data = {};
                    data['lat'] = lat;
                    data['lang'] = lang;
                    data['place'] = place.description;
                    locationData=data;
                    print("locationData $locationData");
                    setState(() {});

                    //move map camera to selected place with animation
                    mapController?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: newlatlang, zoom: 14)));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 2,
                    child: Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListTile(
                          title: widget.type == 'source'?Text(
                            'Search Source',
                            style: TextStyle(fontSize: 18),
                          ):Text(
                            'Search Destination',
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Icon(Icons.search),
                          dense: true,
                        )),
                  ),
                )))
      ]):Center(child: Text("Loading ...")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, locationData);
          // Add your onPressed code here!
        },
        backgroundColor: primary,
        child: const Icon(Icons.check,color: white),
      ),
    );
  }
}
