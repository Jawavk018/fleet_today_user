import 'dart:async';
import '../service/tokenservice/tokenservice.dart';
import '../service/apiservice/apiservice.dart';
import '../service/commonservice/commonservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:user/portal/verification_page.dart';
import '../home/home.dart';
import 'forgot_password_page.dart';
import 'registration_page.dart';
import '../common/theme_helper.dart';
import 'widgets/header_widget.dart';
import 'package:flutter/foundation.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  ApiService? apiService = ApiService();
  TokenService? tokenStorage = TokenService();
  CommonService? commonService = CommonService();

  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();

  Timer? _debounce;
  bool _isDisbled = false;
  bool isOldUser = false;
  bool isLoading = false;
  bool isLoginFailed = false;
  bool isCallApi=false;
  bool isPassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final form = FormGroup({
    "mobileNumber": FormControl(validators: [
      Validators.required,
      Validators.pattern("^((\\+91-?)|0)?[0-9]{10}\$")
    ]),
    "password": FormControl()
  });

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                      const Text(
                        'WELCOME',
                        style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Signin into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      ReactiveForm(
                          formGroup: form,
                          child: Column(
                            children: [
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: ReactiveTextField(
                                  formControlName: 'mobileNumber',
                                  onChanged: _on_change_validate(),
                                  keyboardType: TextInputType.number,
                                  decoration: ThemeHelper().textInputDecoration('Mobile number', 'Enter your mobile number'),
                                  validationMessages: {
                                    ValidationMessage.required: (error) {
                                      return ("Please enter your Mobile number ");
                                    },
                                    ValidationMessage.pattern: (error) =>
                                    "Please enter valid Mobile number ",
                                  },
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              isOldUser == true
                              ? Container(
                                child: ReactiveTextField(
                                  formControlName: 'password',
                                  onChanged: _on_change_validate(),
                                  obscureText: isPassword,
                                  decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              )
                              : Container(),
                              SizedBox(height: 15.0),
                              isOldUser == true
                              ? Container(
                                margin: EdgeInsets.fromLTRB(10,0,10,20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                  },
                                  child: Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                  ),
                                ),
                              )
                              : Container(),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: _isDisbled ? ThemeHelper().buttonStyle():ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(Size(50, 50)),
                                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('Sign In'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ),
                                  onPressed: (){
                                    isOldUser && _isDisbled
                                        ? login()
                                        : !isOldUser && _isDisbled
                                        ? getOtp()
                                        : null;
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerificationPage(data)));
                                  },
                                ),
                              ),
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(10,20,10,20),
                              //   //child: Text('Don\'t have an account? Create'),
                              //   child: Text.rich(
                              //       TextSpan(
                              //           children: [
                              //             TextSpan(text: "Don\'t have an account? "),
                              //             TextSpan(
                              //               text: 'Create',
                              //               recognizer: TapGestureRecognizer()
                              //                 ..onTap = (){
                              //                   Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                              //                 },
                              //               style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).hintColor),
                              //             ),
                              //           ]
                              //       )
                              //   ),
                              // ),
                            ],
                          )
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _on_change_validate() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _isDisbled = form.valid;
      if (form.value['mobileNumber'].toString().length == 10 && !isCallApi) {
        isCallApi=true;
        goToNumberVerify();
      }else if(form.value['mobileNumber'].toString().length != 10){
        isOldUser = false;
        isCallApi=false;
      }
      setState(() {

      });
    });
  }

  goToNumberVerify() async {
    Map<String, dynamic> params = {};
    params['mobileNumber'] = form.value['mobileNumber'];
    var result = (await apiService?.get(
        "8052", "/api/get_verify_mobile_number", params));

    if (result['data'][0]['isMobileNumber'] == true) {
      isOldUser = true;
    } else {
      isOldUser = false;
    }
  }

  login() async {
    print("login");
    isLoading = true;
    Map<String, dynamic> body = {};
    body['mobileNumber'] = form.value['mobileNumber'];
    body['password'] = form.value['password'];
    body['pushToken'] = '12345';
    body['roleCd'] = 5;
    body['timeZone'] = await apiService?.getTimeZone();
    body['deviceTypeName'] = 'Web';
    body['deviceId'] = "12345";
    _isDisbled = true;
    setState(() {});

    var result = (await apiService?.post("8052", "/api/login", body));
    print("result$result");
    isLoading = false;
    _isDisbled = false;
    if (result != null) {
      if (result['isVerifiedUser'] == true) {
        result['isPassword'] = true;
        tokenStorage?.saveUser(result);
        var muthu=tokenStorage?.getUser();
        print("muthu$muthu");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
        commonService?.presentToast("Login Successfully");
      } else {
        _isDisbled = false;
        commonService?.presentToast("Check your mobile number and password");
      }
    } else {}
  }

  getOtp() async {
    Map<String, dynamic> body = {};
    body['mobileNumber'] = form.value['mobileNumber'];
    body['password'] = form.value['password'];
    body['roleCd'] = 5;
    body['deviceId'] = "12345";
    body['pushToken'] = "12345";
    body['timeZone'] = await apiService?.getTimeZone();
    if (defaultTargetPlatform == TargetPlatform.android) {
      body['deviceTypeName'] = 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      body['deviceTypeName'] = 'Ios';
    }
    isLoading = true;
    var result = (await apiService?.post("8052", "/api/signin", body));
    isLoading=false;
    if (result['isLogin']) {
      var data = {};
      data['pushOtp'] = result['pushOtp'];
      data['apiOtp'] = result['apiOtp'];
      data['appUserSno'] = result['appUserSno'];
      data['mobileNumber']=form.value['mobileNumber'];
      isOldUser = true;
      isLoginFailed = false;
      tokenStorage?.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  VerificationPage(data)));
    } else {
      isLoginFailed = true;
      commonService?.presentToast(result['msg']);
    }
  }
}