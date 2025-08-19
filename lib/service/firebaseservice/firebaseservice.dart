import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService{


  initializeApp() async {
    await Firebase.initializeApp();
  }

  getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}