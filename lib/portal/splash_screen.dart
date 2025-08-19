import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import '../color/colors.dart';
import '../home/home.dart';
import '../service/tokenservice/tokenservice.dart';
import 'forgot_password_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool _isVisible = false;
  TokenService?  tokenService = TokenService();

  @override
  void initState() {

    super.initState();
    Timer(
        const Duration(seconds: 5), goToPage);
  }



  goToPage(){
    dynamic user =  tokenService!.getUser();
    print(user);
    if(user != null && user['roleCd']!=null){
      if(user['appUserSno'] != null  && (user['isPassword']==true || user['isPassword']==null)) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
      }
    } else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  const LoginPage()));
    }

  }
  // _SplashScreenState(){

    // new Timer(const Duration(milliseconds: 2000), (){
    //   setState(() {
    //     Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    //   });
    // });

    // new Timer(
    //   Duration(milliseconds: 10),(){
    //     setState(() {
    //       _isVisible = true; // Now it is showing fade effect and navigating to Login page
    //     });
    //   }
    // );

  // }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: new BoxDecoration(
    //     gradient: new LinearGradient(
    //       colors: [Theme.of(context).hintColor, Theme.of(context).primaryColor],
    //       // colors: [Colors.white],
    //       begin: const FractionalOffset(0, 0),
    //       end: const FractionalOffset(1.0, 0.0),
    //       stops: [0.0, 1.0],
    //       tileMode: TileMode.clamp,
    //     ),
    //   ),
    //   // child: AnimatedOpacity(
    //   //   opacity: _isVisible ? 1.0 : 0,
    //   //   duration: Duration(milliseconds: 1200),
    //     child: Center(
    //       child: Container(
    //         height: 140.0,
    //         width: 140.0,
    //         child: Center(
    //             // child: FaIcon(
    //             //   FontAwesomeIcons.bus, size: 80,), //put your logo here
    //           child: Image.asset("assets/images/fleet_today_logo.jpeg"),
    //           ),
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           color: Colors.white,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black.withOpacity(0.3),
    //               blurRadius: 2.0,
    //               offset: Offset(5.0, 3.0),
    //               spreadRadius: 2.0,
    //             )
    //           ]
    //         ),
    //       ),
    //     ),
    // );
    return Container(
      color: white,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1200),
        opacity: 1,
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            // decoration: BoxDecoration(
            //     // shape: BoxShape.circle,
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.3),
            //         blurRadius: 2.0,
            //         offset: const Offset(5.0, 3.0),
            //         spreadRadius: 2.0,
            //       )
            //     ]
            // ),
            child: Center(
              child: Image.asset("assets/images/fleet_today_logo.jpeg"),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: " User",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}