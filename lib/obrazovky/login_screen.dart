import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase/auth.dart';
import 'package:flutter_application_1/obrazovky/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
GlobalKey<FormState> formkey1 = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollView(
                    child: Form(
                  key: formkey1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(children: [
                        Image(image: AssetImage('assets/pesmacka.jpg')),
                        Positioned(
                            height: MediaQuery.of(context).size.height * 0.15,
                            top: MediaQuery.of(context).size.height * 0.27,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40))),
                            )),
                      ]),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Welcome!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 38),
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'Login to continue',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: 15,
                              left: MediaQuery.of(context).size.width * 0.17),
                          child: Stack(children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 47,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 15, right: 5),
                                  hintText: 'Email'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Required";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ])),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: 1,
                              left: MediaQuery.of(context).size.width * 0.17),
                          child: Stack(children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 47,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 15, right: 5),
                                  hintText: 'Password'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Required";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ])),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: SignInButton(
                            Buttons.Google,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () async {
                              await authService.signInwithGoogle();
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.yellow[100],
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30)),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width / 1.5,
                                    47)),
                            onPressed: () {
                              if (formkey1.currentState!.validate()) {
                                if (passwordController.text.length > 6) {
                                  authService.signInWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text);
                                } else {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "PASSWORD TOO SHORT",
                                    desc:
                                        "The password for our app must be longer than 6 characters",
                                  ).show();
                                }
                              }
                            },
                            child: const Text(
                              'LOGIN',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          text: TextSpan(
                            text: 'Dont have an account?',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                  text: ' SIGN UP  ',
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () => Get.off(() => NewUser())),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )))));
  }
}
