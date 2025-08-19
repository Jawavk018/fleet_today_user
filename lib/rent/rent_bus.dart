import 'package:flutter/material.dart';
import '../color/colors.dart';
import '../search bus/source-search.dart';
import '../search bus/view_vehicle_dtl.dart';
import '../service/apiservice/apiservice.dart';
import '../service/commonservice/commonservice.dart';
import '../service/tokenservice/tokenservice.dart';

class RentBus extends StatefulWidget {
  const RentBus({super.key});

  @override
  State<RentBus> createState() => _RentBusState();
}

class _RentBusState extends State<RentBus> {

  TokenService? tokenStorage = TokenService();
  CommonService? commonService = CommonService();
  ApiService apiService = ApiService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var source = TextEditingController();
  var destination = TextEditingController();
  int? sourceCitySno;
  int? destinationCitySno;
  int? stateSno;

  late var routeCity=[];
  late List busList = [];
  late List busDataList = [];

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

  bool isShow = true;

  // final  district;

  late TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        iconTheme: const IconThemeData(
          color: white, //change your color here
        ),
        title: const Text('Rent a bus',style: TextStyle(color: Colors.white),),
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
                    onTap: showSearch,
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
                          height: 50,
                          width: 400,
                          decoration:  BoxDecoration(
                            border: Border.all(
                                color: primary,
                                width: 2
                            ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )
                          ),
                          child: Center(child: Text('${source.text} -> ${destination.text}' ,style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),

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
                                labelText: '  Select State',
                              ),
                            ),
                          ),
                          // Text(":"),
                          // Text(":"),
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
                                labelText: '  Select District',
                              ),
                            ),
                          ),
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
                                  getContactCarrage();
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
                  ),!isShow && busDataList.isEmpty?
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset("assets/images/norecord.png", width: 300,
                      height: 300,),
                  ) :Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    // width: 500,
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: busDataList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print('${busDataList[index]}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewVehicleDtl(busDataList[index], null)),);
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
                                    '${busDataList[index]['vehicleName']}',
                                    style: TextStyle(
                                        color: Colors.black,fontSize: 16, fontWeight: FontWeight.w900),
                                  ),
                                  subtitle: Text(
                                    '${busDataList[index]['vehicleRegNumber']}',
                                    style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w900),
                                  ),
                                ),
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
    //     context, MaterialPageRoute(builder: (context) => SourceSearch(isState:true, isCity: false, isDistrict: false, null)));
    var result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) =>  SourceSearch(type: 'state', null)));
    if(result != null){
      source.text = result['stateName'];
      sourceCitySno=result['stateSno'];
      print('$result');
      stateSno = result['stateSno'];
    }
  }

  getDestList() async {
    // var result = await Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => SourceSearch(isDistrict:true, isCity: false, isState: false, this.stateSno)));
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>  SourceSearch(type: 'district', this.stateSno)));
    if(result != null){
      destination.text = result['districtName'];
      destinationCitySno=result['districtSno'];
      print('$result');
    }else{
    }
    setState(() {});
  }

  getRouteCity() async {
    print('object');
    Map<String, dynamic> params = {};
    params['sourceCitySno'] = sourceCitySno;
    params['destinationCitySno'] = destinationCitySno;
    var result = (await apiService?.get("8054", "/api/get_city_bus", params));
    if(result!=null && result['data']!=null){
      routeCity=result['data'];
      setState(() {});
      print('$routeCity');
    }
  }

  getContactCarrage() async {
    Map<String, dynamic> params = {};
    var result =
    (await apiService?.get("8058", "/api/get_contact_carrage", params));
    print("$result");
    busList = result['data'];
    for (var bus in busList) {
      if (bus['districtName'] == destination.text) {
        print('$bus');
        busDataList.add(bus);
        print('$busDataList');
      }
    }
    setState(() {});
  }


}
