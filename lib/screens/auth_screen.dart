import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iot_project/provider/auth_provider.dart';
import 'package:iot_project/screens/home_screen.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = false;
  bool _isVisible = true;
  late TapGestureRecognizer onTapRecogniser;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  void _handlePress (){
    setState((){
      _isLogin = !_isLogin;
    });
  }

  Future<void> signUp() async{
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty || _usernameController.text.isEmpty){
      return ;
    }
    bool isUser = await AuthProvider().registerUser(_emailController.text, _passwordController.text, _usernameController.text);
    if(isUser == true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      FlutterError("Something Went Wrong");
    }
  }

  Future<void> signIn() async{
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      return ;
    }
    bool isUser = await AuthProvider().signInUser(_emailController.text, _passwordController.text);
    if(isUser == true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      FlutterError("Something Went Wrong");
    }
  }

  @override
  void initState(){
    super.initState();
    onTapRecogniser = TapGestureRecognizer()..onTap = _handlePress;
  }

  @override
  void dispose(){
    onTapRecogniser.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: 100.w,
            height: 100.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            alignment: Alignment.center,
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png",height: 45.h,width: 100.w,),
                    _isLogin
                    ? Container()
                    : TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black,fontSize: 5.w,fontWeight: FontWeight.w500),
                      decoration: kInputDecoration,
                      controller: _usernameController,
                    ),
                    SizedBox(height: 4.h,),
                    TextFormField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black,fontSize: 5.w,fontWeight: FontWeight.w500),
                      decoration: kInputDecoration.copyWith(labelText: "Email"),
                      controller: _emailController,
                    ),
                    SizedBox(height: 4.h,),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: _passwordController,
                      style: TextStyle(color: Colors.black,fontSize: 5.w,fontWeight: FontWeight.w500),
                      obscureText: _isVisible,
                      decoration: kInputDecoration.copyWith(
                        labelText: "Password",
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState((){
                              _isVisible = !_isVisible;
                            });
                          },
                          child: Icon(_isVisible ? Icons.visibility : Icons.visibility_off,color: Colors.black,),
                        )
                      ),
                    ),
                    SizedBox(height: 4.h,),
                    _isLogin
                    ? RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "Don't have an account ?  ",style: TextStyle(fontSize: 3.w,fontWeight: FontWeight.w500,color: Colors.black)),
                          TextSpan(
                              recognizer: onTapRecogniser,
                              text: "Signup here",style: TextStyle(fontSize: 3.5.w,fontWeight: FontWeight.w600,color: Color(0xFF7A5CE0))),
                        ]
                    ))
                    : RichText(text: TextSpan(
                      children: [
                        TextSpan(text: "Already have an account ?  ",style: TextStyle(fontSize: 3.w,fontWeight: FontWeight.w500,color: Colors.black)),
                        TextSpan(
                            recognizer: onTapRecogniser,
                            text: "Login here",style: TextStyle(fontSize: 3.5.w,fontWeight: FontWeight.w600,color: Color(0xFF7A5CE0))),
                      ]
                    )),
                    SizedBox(height: 4.h,),
                    GestureDetector(
                      onTap: () async{
                        _isLogin
                            ? await signIn()
                            : await signUp();
                      },
                      child: Container(
                        width: 30.w,
                        height: 6.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFF7A5CE0),
                          borderRadius: BorderRadius.circular(14.0)
                        ),
                        child: Text( _isLogin ? "Log In"  : "Sign Up",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 4.w,color: Colors.white),),
                      ),
                    ),
                    SizedBox(height: 4.h,)
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
