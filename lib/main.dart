import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:user/home/home.dart';
import 'package:user/portal/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  Color _primaryColor = HexColor('#DC54FE');
  Color _accentColor = HexColor('#8A02AE');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      theme: ThemeData(
        primaryColor: _primaryColor,
        hintColor: _accentColor,
        scaffoldBackgroundColor: Color(0xFDF8F8F8),
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

