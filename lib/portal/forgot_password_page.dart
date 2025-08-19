import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../service/apiservice/apiservice.dart';
import '../service/tokenservice/tokenservice.dart';
import '../service/commonservice/commonservice.dart';
import 'package:user/home/home.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../common/theme_helper.dart';
import 'verification_page.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  ApiService? apiService = ApiService();
  TokenService? tokenStorage = TokenService();
  CommonService? commonService = CommonService();
  bool _passwordVisible = true;
  bool confirmPasswordVisible = true;
  Timer? _debounce;
  bool isLoading = false;
  bool isDisbled = false;
  var width, height;
  late var user;
  List<dynamic> passwordRules = [
    {"rule": "Length in-between 6 to 15 character"},
    {"rule": "Your New password should match with confirm New password"}
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  final loginForm = FormGroup({
    "appUserSno":  FormControl(),
    "password": FormControl(validators: [
      Validators.required,
      Validators.minLength(6),
      Validators.maxLength(15)
    ]),
    "confirmPassword": FormControl(validators: [
      Validators.required,
      Validators.minLength(6),
      Validators.maxLength(15)
    ]),
  });

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    user=tokenStorage?.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
        child: ReactiveForm(
        formGroup: loginForm,
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.password_rounded),
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
                            Text('Set Password?',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),

                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: ReactiveTextField(
                                onChanged: _on_change_validate(),
                                formControlName: 'password',
                                obscureText: _passwordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                decoration:  InputDecoration(
                                  labelText: "Password",
                                  hintText: "Enter your password",
                                  fillColor: Colors.white,
                                  filled: true,
                                    suffixIcon: IconButton(
                                        icon: Icon(_passwordVisible
                                            ? Icons.lock
                                            : Icons.lock_open),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                            !_passwordVisible;
                                          });
                                        }),
                                  // suffixIcon: Icon(Icons.icecream_outlined),
                                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                ),
                                validationMessages: {
                                  ValidationMessage.required: (error) {
                                    return ("Please enter New password");
                                  },
                                  ValidationMessage.minLength: (error) =>
                                  "Password should have minimum 6 characters",
                                  ValidationMessage.maxLength: (error) =>
                                  "Password should have maximum 15 characters"
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: ReactiveTextField(
                                onChanged: _on_change_validate(),
                                obscureText: confirmPasswordVisible,
                                formControlName: 'confirmPassword',
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  labelText: "Confirm password",
                                  hintText: "Enter your confirm password",
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: IconButton(
                                      icon: Icon(confirmPasswordVisible
                                          ? Icons.lock
                                          : Icons.lock_open),
                                      onPressed: () {
                                        setState(() {
                                          confirmPasswordVisible =
                                          !confirmPasswordVisible;
                                        });
                                      }) ,
                                  // suffixIcon: Icon(Icons.icecream_outlined),
                                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                ),
                                validationMessages: {
                                  ValidationMessage.required: (error) {
                                    return ("Please enter confirm new password ");
                                  },
                                  ValidationMessage.minLength: (error) =>
                                  "Password should have minimum 6 characters",
                                  ValidationMessage.maxLength: (error) =>
                                  "Password should have maximum 15 characters"
                                },
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: isDisbled ? ThemeHelper().buttonStyle():ButtonStyle(
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
                                  padding: const EdgeInsets.fromLTRB(
                                      40, 10, 40, 10),
                                  child: Text(
                                    "Send".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                    isDisbled==true ? goToHome() :  null;
                                  }
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Remember your password? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginPage()),
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
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
    ),);
  }
  _on_change_validate() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(loginForm.value['password']==loginForm.value['confirmPassword']){
        isDisbled = loginForm.valid;
        print(loginForm.valid);
      }
      setState(() {

      });
    });
  }
  goToHome() async{
    if(user!=null){
      // print("user $user");
      // loginForm.patchValue({
      //   "appUserSno":user['appUserSno']
      // });
      Map<String,dynamic> body={};
      body['appUserSno']=user['appUserSno'];
      body['password']=loginForm.value['password'];
      body['confirmPassword']=loginForm.value['confirmPassword'];

      var result = (await apiService?.put("8052", "/api/update_app_user", body));
      if (result != null ) {
        user['isPassword'] = true;
        tokenStorage?.saveUser(user);
        // loginForm.reset();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home()),
        );
        commonService?.presentToast('Saved Successfully');
      }

    }

  }
}
