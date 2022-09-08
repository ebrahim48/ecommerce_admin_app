// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../widgets/show_loading.dart';
import 'launcher_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "login-page";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String _errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  bool _isLoading = false;

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [

                  const Text(
                    "Admin Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        fontStyle: FontStyle.normal),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/images/login.jpg",
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // todo This is email textField section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffe6e6e6),
                          contentPadding: const EdgeInsets.only(left: 10),
                          focusColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.email,
                          ),
                          hintText: "Enter your email",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.normal),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  // todo this is password textField section
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: passwordController,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffe6e6e6),
                          contentPadding: EdgeInsets.only(left: 10),
                          focusColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.normal),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "forget password?",
                          ))),
                _isLoading? ShowLoading():  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    child: ElevatedButton(
                        onPressed: _chechValidet,
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        child: Text(
                          "LogIn",
                          style: TextStyle(fontSize: 16),
                        )),
                  ),

                ],
              )),
        ),
      ),
    );
  }

  void _chechValidet() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {

       final status =   await AuthService.login(emailController.text, passwordController.text);
       if(status){
         if(mounted){
           Navigator.pushReplacementNamed(context, LauncherPage.routeName);
         }
       }
       else{
         AuthService.logout();
         setState(() {
           _isLoading = false;
         });
         _errorMessage = "You are not admin";
       }



      } on FirebaseAuthException catch (e) {
        setState(() {
          setState(() {
            _isLoading = false;
          });
          _errorMessage = e.message!;
        });
      }
    }
  }
}