import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';

class CommonService extends ChangeNotifier{

  presentToast(message,{ gravity }){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: gravity != null ? gravity : ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        // fontSize: 16.0
    );
  }

  getDeviceId() async {
    try {
      return await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      return '';
    }
  }

  emptyCheck(data){
    return data != null && data.length == 0 ? true : false;
  }

}
