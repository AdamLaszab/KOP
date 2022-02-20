import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase/auth.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:form_field_validator/form_field_validator.dart';

class NewUser extends StatefulWidget {
  _NewUser createState() => _NewUser();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController passwordController1 = TextEditingController();
GlobalKey<FormState> formkey = GlobalKey<FormState>();

class _NewUser extends State<NewUser> {
  @override
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
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    Image(image: AssetImage('assets/pesmacka.jpg')),
                    Positioned(
                        height: 50,
                        top: MediaQuery.of(context).size.height * 0.27,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60)),
                        )),
                  ]),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Create your account',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30),
                      )),
                  Form(
                      key: formkey,
                      child: Column(children: [
                        Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 15),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black)),
                                ),
                                child: TextFormField(
                                    controller: emailController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15, right: 5, top: 15),
                                        hintText: 'Email'),
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: "Required"),
                                      EmailValidator(
                                          errorText: "Not a valid email")
                                    ])))),
                        Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black)),
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  style: TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15, right: 5, top: 15),
                                      hintText: 'Password'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                ))),
                        Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black)),
                                ),
                                child: TextFormField(
                                  controller: passwordController1,
                                  obscureText: true,
                                  style: TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15, right: 5, top: 15),
                                      hintText: 'Confirm your password'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                )))
                      ])),
                  Padding(
                      padding: EdgeInsets.only(top: 70, bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[100],
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30)),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width / 1.5, 47)),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            if (passwordController.text.length > 6) {
                              if (passwordController.text ==
                                  passwordController1.text) {
                                authService.createUserWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);
                                Get.toNamed('/');
                              } else {
                                Get.dialog(SimpleDialog(
                                  backgroundColor: Colors.red,
                                  title: Text(
                                    'Passwords do not match',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black87),
                                  ),
                                  children: [],
                                ));
                                formkey.currentState!.reset();
                              }
                            } else {
                              Get.dialog(SimpleDialog(
                                backgroundColor: Colors.red,
                                title: Text(
                                  'Password is too short',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black87),
                                ),
                                children: [],
                              ));
                              formkey.currentState!.reset();
                            }
                          } else {
                            print("Not Validated");
                          }
                        },
                        child: const Text(
                          'CREATE ACCOUNT',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
