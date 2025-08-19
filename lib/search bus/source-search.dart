import 'package:flutter/material.dart';
import 'package:user/search%20bus/search_bus.dart';
import 'package:user/service/apiservice/apiservice.dart';

import '../color/colors.dart';

import '../service/commonservice/commonservice.dart';
import '../service/tokenservice/tokenservice.dart';

class SourceSearch extends StatefulWidget {

  // final bool isCity;
  // final bool isState;
  // final bool isDistrict;
  final stateSno;
  final type;

   // SourceSearch(this.stateSno, {Key? key,required this.isCity, required this.isState, required this.isDistrict,}) : super(key: key);
  const SourceSearch(this.stateSno, {this.type,});


  @override
  State<SourceSearch> createState() => _SourceSearchState();
}

class _SourceSearchState extends State<SourceSearch> {
  TextEditingController _textController = TextEditingController();
  TokenService? tokenStorage = TokenService();
  CommonService? commonService = CommonService();
  ApiService apiService = ApiService();

  late List<dynamic> mainDataList = [];
  List<dynamic>? newDataList;

  late List<dynamic> districtMainDataList = [];
  List<dynamic>? newDistrictList;

  late List<dynamic> stateDataList = [];
  List<dynamic>? newStateList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.stateSno != null){
      print('${widget.stateSno}');
    }

    print('WIDGET TYPE${widget.type}');

    if(widget.type == 'citySource'){
      getSource();
    }if(widget.type == 'cityDestination'){
      getSource();
    }if(widget.type == 'state'){
      getState();
    }if(widget.type == 'district'){
      getDistrict();
    }

  }

  // onItemChanged(String value) {
  //   newDataList = mainDataList.where((string) {
  //     return string['cityName'].toLowerCase().contains(value.toLowerCase());
  //   }).toList();
  //   setState(() {});
  // }

  onItemChangedCity(String value) {
    newDataList = mainDataList.where((string) {
      return string['cityName'].toLowerCase().contains(value.toLowerCase());
    }).toList();
    setState(() {});
  }

  onItemChangedDistrict(String value) {
    newDistrictList = districtMainDataList.where((string) {
      return string['districtName'].toLowerCase().contains(value.toLowerCase());
    }).toList();
    setState(() {});
  }

  onItemChangedState(String value) {
    newStateList = stateDataList.where((string) {
      return string['stateName'].toLowerCase().contains(value.toLowerCase());
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    Widget appBarTitle() {
      if (widget.type == 'citySource' ) {
        return const Text("Select Source", style: TextStyle(color: Colors.white));
      }
      if(widget.type == 'cityDestination'){
        return const Text("Select Destination", style: TextStyle(color: Colors.white));
      }
      if(widget.type == 'state'){
        return const Text("Select State", style: TextStyle(color: Colors.white));
      }
      else{
        return const Text("Select District", style: TextStyle(color: Colors.white));
      }
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: white, //change your color here
        ),
        backgroundColor: primary,
        // title: widget.isCity?Text("Select Source",style: TextStyle(color: Colors.white)):
        // widget.isState?Text("Select State",style: TextStyle(color: Colors.white)):
        // Text("Select Destination",style: TextStyle(color: Colors.white)),
        title: appBarTitle(),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              autofocus: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Here...',
              ),
              // onChanged: widget.isCity?onItemChangedCity:widget.isDistrict?onItemChangedDistrict:onItemChangedState,
              onChanged: widget.type == 'state'? onItemChangedState:
                         widget.type == 'district'? onItemChangedDistrict: onItemChangedCity,
            ),
          ),
          Expanded(
            child: newDataList != null && newDataList!.length > 0
                ? ListView(
                    padding: EdgeInsets.all(12.0),
                    children: newDataList!.map((data) {
                      return ListTile(
                          title: Text(data["cityName"]),
                          onTap: () {
                            print(data);
                            Navigator.pop(context, data);
                          });
                    }).toList(),
                  )
                : newStateList != null && newStateList!.length > 0? ListView(
              padding: EdgeInsets.all(12.0),
              children: newStateList!.map((data) {
                return ListTile(
                    title: Text(data["stateName"]),
                    onTap: () {
                      print(data);
                      Navigator.pop(context, data);
                    });
              }).toList(),
            ): newDistrictList != null && newDistrictList!.length > 0? ListView(
              padding: EdgeInsets.all(12.0),
              children: newDistrictList!.map((data) {
                return ListTile(
                    title: Text(data["districtName"]),
                    onTap: () {
                      print(data);
                      Navigator.pop(context, data);
                    });
              }).toList(),
            ):Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset("assets/images/norecord.png", width: 300,
                    height: 300,),
                )
            ),
          )
        ],
      ),
    );
  }


  getSource() async {
    Map<String, dynamic> params = {};
    var result = (await apiService?.get("8054", "/api/get_city", params));
    print(result);
    if(result!=null){
      mainDataList = result['data'];
    }
    newDataList = List.from(mainDataList);
    setState(() {});
  }

  getDistrict() async {
    Map<String, dynamic> params = {};
    params['stateSno'] = widget.stateSno;
    print('$params');
    var result = (await apiService?.get("8054", "/api/get_district", params));
    print('$result');
    if(result!=null && result['data']!=null){
      districtMainDataList = result['data'];
      newDistrictList = List.from(districtMainDataList);
    }else{
    }
    setState(() {});
  }

  getState() async {
    Map<String, dynamic> params = {};
    var result = (await apiService?.get("8054", "/api/get_state", params));
    print(result);
    if(result!=null){
      stateDataList = result['data'];
    }
    newStateList = List.from(stateDataList);
    setState(() {});
  }
}
