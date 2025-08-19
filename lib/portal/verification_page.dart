import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../service/apiservice/apiservice.dart';
import '../service/tokenservice/tokenservice.dart';
import '../service/commonservice/commonservice.dart';
import '../service/firebaseservice/firebaseservice.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:user/portal/forgot_password_page.dart';
import '../common/theme_helper.dart';
import 'widgets/header_widget.dart';

class VerificationPage extends StatefulWidget {
  final data;
  const VerificationPage(this.data, {Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _GetVerificationPageState();
}

class _GetVerificationPageState extends State<VerificationPage> {
  ApiService? apiService = ApiService();
  CommonService? commonService = CommonService();
  TokenService? tokenService = TokenService();
  FirebaseService? firebaseService = FirebaseService();
  Timer? _debounce;
  var deviceId = 0;
  late var user;
  OtpFieldController otpbox = OtpFieldController();

  final _formKey = GlobalKey<FormState>();
  String pin='';

  @override
  void initState() {
    super.initState();
    user=tokenService?.getUser();
    setState(() {
      print("user$user");
    });// deviceId = (await PlatformDeviceId.getDeviceId)! as int;
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    OtpFieldController otpController = OtpFieldController();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(
                    _headerHeight, true, Icons.privacy_tip_outlined),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Enter the verification code we just sent you on your email address.',
                              style: TextStyle(
                                // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            OTPTextField(
                            controller: otpController,
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldWidth: 45,
                            fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 15,
                            style: TextStyle(fontSize: 17),
                            onChanged: (pin) {
                              if(pin.length==6){
                                verifyOtp(pin);
                              }
                            },
                            ),
                            const SizedBox(height: 50.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "If you didn't receive a code! ",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog("Successful",
                                                "Verification code resend successful.",
                                                context);
                                          },
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: pin.length==6 ? ThemeHelper().buttonBoxDecoration(context):ThemeHelper().buttonBoxDecoration(context, "#AAAAAA","#757575"),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      40, 10, 40, 10),
                                  child: Text(
                                    "Verify".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: pin.length==6 ? () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => ForgotPasswordPage()
                                      ),
                                          (Route<dynamic> route) => false
                                  );
                                } : null,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  verifyOtp(value) async {
    Map<String,dynamic> body={};
    body['deviceId']= "12345";
    body['loginTime'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    body['timeZone'] = await apiService?.getTimeZone();
    body['deviceTypeName'] = 'Android';
    body['roleCd'] = 5;
    body['mobileNumber'] = widget.data['mobileNumber'];
    body['appUserSno'] = widget.data['appUserSno'];
    body['simOtp'] = value;
    body['pushOtp'] = widget.data['pushOtp'];
    body['apiOtp'] = widget.data['apiOtp'];

    var result=(await apiService?.post("8052", "/api/verify_otp", body));
    print("result$result");
    if (result?['isVerifiedUser']) {
      if (result['appUserSno'] != null) {
        var data = result;
        if (result['isVerifiedUser']) {
          data.remove('isVerifiedUser');
          data['isPassword']=false;
          print("data$data");
          tokenService?.saveUser(data);
          commonService?.presentToast("Login Success");
          if ( user==null || !user['isPassword']) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  ForgotPasswordPage()));
          }
        } else {
          commonService?.presentToast("Invalid OTP");
        }
      } else {
        commonService?.presentToast("You are OTP is expired. Please press Resend OTP");

      }
    } else {
      commonService?.presentToast("Invalid OTP");
    }
    // Navigator.pushNamed(context, '/SignIn');

  }
}
