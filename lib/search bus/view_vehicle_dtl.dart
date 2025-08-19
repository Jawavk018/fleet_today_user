import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../color/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ViewVehicleDtl extends StatefulWidget {
  final bus;
  final amount;
  const ViewVehicleDtl(this.bus, this.amount, {Key? key}) : super(key: key);

  @override
  State<ViewVehicleDtl> createState() => _ViewVehicleDtlState();
}

class _ViewVehicleDtlState extends State<ViewVehicleDtl> {
  VideoPlayerController? _controller;
  late ChewieController? _chewieController;
  int currentIndex = 0;

  List vehicleImageList = [];

  List addList = [
    {"addSno": "1", "addBanner": "assets/images/8.jpeg"},
    {"addSno": "2", "addBanner": "assets/images/7.jpeg"},
    {"addSno": "3", "addBanner": "assets/images/6.jpeg"},
    {"addSno": "4", "addBanner": "assets/images/5.jpeg"},
    {"addSno": "5", "addBanner": "assets/images/4.jpeg"},
  ];

  bool isFullImageVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('${widget.bus}');
    if (widget?.bus?['media'] != null) {
      vehicleImageList = widget?.bus?['media'];
      print('${vehicleImageList}');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
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
        title: const Text('Vehicle Info', style: TextStyle(color: white)),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Card(
                color: Colors.white,
                surfaceTintColor: white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          vehicleImageList.isNotEmpty
                              ? CarouselSlider(
                            items: [
                              for (int i = 0; i < vehicleImageList.length; i++)
                                vehicleImageList[i]['mediaType'] ==
                                    "Video"
                                    ? Chewie(
                                  controller: _chewieController =
                                      ChewieController(
                                        videoPlayerController: _controller =
                                            VideoPlayerController.network(
                                                '${vehicleImageList[i]['mediaUrl']}'),
                                        aspectRatio: 16 / 9,
                                        // autoPlay: false,
                                        looping: false,
                                        // fullScreenByDefault: true,
                                      ),
                                )
                                    :GestureDetector(
                                        onTap: (){
                                          print('Image is Presses');
                                          print('${vehicleImageList[i]['mediaUrl']}');
                                          viewFullImage(context,'${vehicleImageList[i]['mediaUrl']}');
                                        },
                                        child: Container(
                                  decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${vehicleImageList[i]['mediaUrl']}"),
                                          fit: BoxFit.contain,
                                        ),
                                  ),
                                ),
                                      ),
                            ],
                            options: CarouselOptions(
                              // scrollDirection: Axis.vertical,
                                height: 200.0,
                                // autoPlay: true,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                                viewportFraction: 1,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    print(reason.toString());
                                    currentIndex = index;
                                  });
                                }),
                          )
                              : CarouselSlider(
                            items: [
                              // for (int i = 0; i < addList.length; i++)
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      // Image.asset("assets/images/$i.jpeg")
                                      image: AssetImage(
                                          "assets/images/img-not-found.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                            ],
                            options: CarouselOptions(
                              height: 200.0,
                              autoPlay: true,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                              viewportFraction: 1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < vehicleImageList.length; i++)
                                Container(
                                  height: 8,
                                  width: 8,
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: currentIndex == i
                                          ? Colors.blue
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(2, 2))
                                      ]),
                                )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('${widget.bus['vehicleName']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: widget.amount != null? const Text('Approximate',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: secondary)):Text(''),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                        '${widget.bus['seatType']} |'
                                        // ' ${widget.bus['seatCapacity']} Seats',
                                        ,style: TextStyle(
                                        fontSize: 14, color: secondary)
                                    ),
                                    widget.bus['seatCapacity'] != null?
                                    Text(
                                      // '${widget.bus['seatType']} |'
                                        ' ${widget.bus['seatCapacity']} Seats',
                                        style: TextStyle(
                                            fontSize: 14, color: secondary)
                                    ):Text(' --- Seats',style: TextStyle(
                                        fontSize: 14, color: secondary)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: widget.amount != null? Text('₹ ${widget.amount}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: success)):Text(''),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.charging_station),
                          Icon(Icons.music_note),
                          Icon(Icons.luggage),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: btnblue,
                              // padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              viewAmenities(context);
                            },
                            child: const Text('VIEW AMENITIES'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                surfaceTintColor: white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/fuel_img.png',
                              width: 35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text('Fuel Type',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: -4),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/radio.png',
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-20, 0),
                        child: widget.bus['fuelType'] != null?
                        Text('${widget.bus['fuelType']}'):const Text(' --- '),
                      ),
                      subtitle: Transform.translate(
                        offset: Offset(-20, 0),
                        child: widget.amount != null? Text('starts at ₹ ${widget.amount}'):Text(''),
                      ),
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/bustype.jpg',
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text('Bus Type',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                    ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/radio.png',
                            width: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('${widget.bus['coolType']}'),
                        )),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/bustype.jpg',
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text('Vehicle Model',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                    ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/radio.png',
                            width: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: widget.bus['vehicle_model'] != null?
                          Text('${widget.bus['vehicle_model']}'):Text(' --- '),
                        )),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/luggages.png',
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text('  Luggage Carrier',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                    ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/radio.png',
                            width: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('${widget.bus['luckageCount']}'),
                        )),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> viewAmenities(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Text("Amenities",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'The vehicle may have the following Amenities',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.charging_station),
                  title: Text('Charging Point'),
                ),
                ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text('Music System'),
                ),
                ListTile(
                  leading: Icon(Icons.luggage),
                  title: Text('Overhead Storage'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

   viewFullImage(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            child: PhotoView(
              imageProvider: NetworkImage(link),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              backgroundDecoration: BoxDecoration(
                color: Colors.transparent, // Make the PhotoView background transparent
              ),
            ),
          ),
        );
      },
    );
  }

}