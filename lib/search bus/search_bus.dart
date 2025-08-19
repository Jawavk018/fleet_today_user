import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:user/search%20bus/source-search.dart';
import 'package:user/search%20bus/view_vehicle_dtl.dart';
import '../color/colors.dart';
import 'package:intl/intl.dart';
import '../service/apiservice/apiservice.dart';
import '../service/commonservice/commonservice.dart';
import '../service/tokenservice/tokenservice.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';



class SearchBus extends StatefulWidget {
  const SearchBus({Key? key}) : super(key: key);

  @override
  State<SearchBus> createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  TokenService? tokenStorage = TokenService();
  CommonService? commonService = CommonService();
  ApiService apiService = ApiService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var source = TextEditingController();
  var destination = TextEditingController();
  var via = TextEditingController();
  int? sourceCitySno;
  int? destinationCitySno;
  Set<int>? viaCitySno;
  bool isCheckController = false;
  late var routeCity=[];
  late var viaList=[];
  var swappingText;
  int? swapCitySno;
  bool isShow = true;
  bool isChange = false;
  late TextEditingController controller;
  Timer? _debounce;
  bool isDisabled = true;

  void _SwappingSourDest() {
    swappingText = source;
    source = destination;
    destination = swappingText;

    swapCitySno = sourceCitySno;
    sourceCitySno = destinationCitySno;
    destinationCitySno = swapCitySno;

    if(isChange){
      print('$isChange');
      getRouteCity();
    }
    setState(() {
      getViaCity();
    });
  }
  // DateTime now = DateTime.now();
  // String datetime2 = DateFormat.Hm().format(datetime);

  void showSearch() {
    setState(() {
      isShow = !isShow;
    });
  }

  void dispose() {
    source.dispose();
    destination.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        iconTheme: const IconThemeData(
          color: white, //change your color here
        ),
        title: const Text('Find a bus',style: TextStyle(color: Colors.white),),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !isShow
                      ? GestureDetector(
                          // onTap: showSearch,
                             onTap: () {
                                showSearch();
                                isChange = true;
                              },
                          child: Column(
                            children: [
                              Container(
                                // color: primary,
                                decoration: const BoxDecoration(
                                  color: primary,
                                    // border: Border.all(
                                    //   // color: Colors.black,
                                    // ),
                                    // borderRadius: BorderRadius.all(Radius.circular(15))
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15)
                                    )
                                ),
                                child: const ListTile(
                                  leading: Icon(
                                    Icons.search,color: white,
                                  ),
                                  title: Text(
                                    "Search",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold,color: white),
                                  ),
                                ),
                              ),
                              Container(
                                height: 100, // Adjust the height as needed
                                width: 400,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${source.text} -> ${destination.text}',
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                    ),
                                    // SizedBox(height: 5), // Add some spacing between the text fields
                                    if (routeCity.isNotEmpty) // Check if routeCity is not empty
                                      Text(
                                        '${routeCity[0]['cityName']}',
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                      ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 10,
                        ),
                  Container(
                    child: Visibility(
                      visible: isShow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: TextField(
                              onTap: () {
                                  getSetList();
                              },
                              controller: source,
                              autofocus: false,
                              readOnly: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.location_on,color: success),
                                border: OutlineInputBorder(),
                                labelText: '  Source',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:10,bottom: 10,left:20.0,right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
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
                                    SizedBox(height: 3),
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
                                InkWell(
                                  onTap: () {
                                    _SwappingSourDest();
                                  },
                                    child: Image.asset(
                                      'assets/images/double-arrow.png',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.fill,
                                      color: Colors.black45,
                                    ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: TextField(
                              onTap: () async {
                                setState(() {
                                  getDestList();
                                });
                              },
                              controller: destination,
                              autofocus: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on,color: danger),
                                labelText: '  Destination',
                              ),
                            ),
                          ),
                          viaList.isNotEmpty ? Padding(
                            padding: const EdgeInsets.only(top:10,bottom: 10,left:20.0,right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
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
                                    SizedBox(height: 3),
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
                              ],
                            ),
                          ):Container(),

                          viaList.isNotEmpty ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 20.0),
                              //   child: Text(" Licence Type *",style: TextStyle(fontSize: 16),),
                              // ),
                              Container(
                                // margin: const EdgeInsets.all(15.0),
                                child: MultiSelectDialogField(
                                  searchable: true,
                                  buttonText: const Text('Select Via'),
                                  buttonIcon: Icon(Icons.arrow_drop_down),
                                  cancelText: const Text('Cancel'),
                                  dialogHeight: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // onSelectionChanged: onChangeValidate(),
                                  items: viaList != null &&
                                      viaList.isNotEmpty
                                      ? viaList
                                      .map((dynamic e) => MultiSelectItem(
                                      e['viaSno'], e['viaName']))
                                      .toList()
                                      : [],
                                  // initialValue: user['driverSno']!=null ?  widget.profile[0]?['drivingLicenceType']!=[] ?  widget.profile[0]?['drivingLicenceType']: [] : [],
                                  // initialValue: user['driverSno'] != null ? widget.profile!=null?widget.profile[0]['drivingLicenceType']:drivingEnumList : (profile.value['drivingLicenceType'] != null ? profile.value['drivingLicenceType'] : []),
                                  title: Text("Select Via",style: TextStyle(fontSize: 14)),
                                  onConfirm: (results) {
                                    print("$results");
                                    // Assuming results is List<int>
                                    viaCitySno = results.cast<int>().toSet();
                                    print("$viaCitySno");
                                  },
                                ),
                              ),
                            ],
                          ):Container(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary, // NEW
                                ),
                                onPressed: () {
                                  getRouteCity();
                                  showSearch();
                                },
                                // onPressed: showSearch,
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: Text(
                                  "Search",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),!isShow && routeCity.isEmpty?
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset("assets/images/norecord.png", width: 300,
                      height: 300,),
                  )
                 : Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    // width: 500,
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: routeCity.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print('route');
                            // print('route${routeCity[index]}');
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ViewVehicleDtl(bus, (double.parse(value!) * (bus['pricePerDay'] / 400)).toStringAsFixed(2))),);
                          },
                          child: Card(
                            color: Colors.white,
                            surfaceTintColor: white,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(top:10.0),
                                    child: Icon(
                                      Icons.directions_bus,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  title: Text(
                                    '${routeCity[index]['vehicleName']}',
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${routeCity[index]['vehicleRegNumber']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(top:25.0),
                                    child: Text(
                                      '${ DateFormat.jm().format(DateTime.parse(routeCity[index]['startingTime']))}',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Divider(
                                    indent: 20,
                                    endIndent: 20
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left:15.0, right: 15.0, bottom: 15.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Expanded(
                                //         child: Container(
                                //           child: Row(
                                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //
                                //             children: [
                                //               Icon(Icons.location_on_outlined, size: 20,
                                //                 color: Colors.green,),
                                //               Expanded(child: Text('${source.text}')),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //       Expanded(child: Center(child: Text('to'))),
                                //       // SizedBox(width: 50,),
                                //       Expanded(
                                //         child: Container(
                                //           child: Row(
                                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //
                                //             children: [
                                //               Icon(Icons.location_on_outlined, size: 20,
                                //                 color: Colors.red, ),
                                //               Expanded(child: Text('${destination.text}'))
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Divider(
                                //     indent: 20,
                                //     endIndent: 20
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left:15.0, right: 15.0, bottom: 15.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/via-route.png',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(width: 10,),
                                      routeCity[index]['cityName'] != null
                                          ? Padding(
                                        padding: const EdgeInsets.only(top:15.0),
                                        child: Text(
                                            '${routeCity[index]['cityName']}'),
                                      )
                                          : Padding(
                                        padding: const EdgeInsets.only(top:15.0),
                                        child: Text(
                                            'No Via Route Found'),
                                      ),
                                      // Expanded(child: Text('Shollinganallour,STPI,Adyar,TNagar,Navallour,chennai,Shollinganallour')),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getSetList() async {
    // var result = await Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => SourceSearch(isCity:true, isState: false, isDistrict: false, null)));
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>  SourceSearch(type: 'citySource', null)));
    if(result != null){
      source.text = result['cityName'];
      sourceCitySno=result['citySno'];
      print('$result');
    }
  }

  getDestList() async {
    // var result = await Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => SourceSearch(isCity:true, isState: false, isDistrict: false, null)));
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>  SourceSearch(type: 'cityDestination', null)));
    if(result != null){
      destination.text = result['cityName'];
      destinationCitySno=result['citySno'];
      print('$result');
    }
    setState(() {});
    print('$result');
    getViaCity();
  }

  getRouteCity() async {
    print('object');
    Map<String, dynamic> params = {};
    params['sourceCitySno'] = sourceCitySno;
    params['destinationCitySno'] = destinationCitySno;
    if(viaCitySno != null){
      params['viaCitySno'] = viaCitySno;
    }
    params['createdOn'] = await apiService?.getTimeZone();
    print('${params}');
    var result = (await apiService?.get("8054", "/api/get_city_bus", params));
    if(result!=null && result['data']!=null){
      routeCity = result['data'];
      setState(() {});
      print('$routeCity');
      for (int i = 0; i < routeCity.length; i++) {
        if(routeCity[i]['cityName'] != null){
          List<String> cityNameList = routeCity[i]['cityName'].cast<String>();
          String cityName = cityNameList.join(', ');
          routeCity[i]['cityName'] = cityName;
          print('routeCity$routeCity');
        }else{
          routeCity[i]['cityName'] = null;
        }
      }
    }
  }

  checkTextController() async {
    if (source.text.isNotEmpty &&
        destination.text.isNotEmpty) {
      isCheckController = true;
    }
  }

  getViaCity() async {
    this.viaList = [];
    Map<String, dynamic> params = {};
    params['sourceCitySno'] = sourceCitySno;
    params['destinationCitySno'] = destinationCitySno;
    print('$params');
    var result = (await apiService?.get("8054", "/api/get_via_route", params));
    if(result!=null && result['data']!=null){
    viaList=result['data'];
    setState(() {});
    print('$viaList');
    }else{
      viaList = [];
      print('$viaList');
    }
  }

  // onChangeValidate() {
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     setState(() {
  //       isDisabled = profile.invalid;
  //     });
  //   });
  // }

}
