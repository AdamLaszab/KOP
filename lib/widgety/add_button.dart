import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

bool _hasBeenPressed = true;
bool _hasPicture = false;
bool _hasPicture1 = false;
CollectionReference dogs = FirebaseFirestore.instance.collection('dogs');

class PridavaniePsov extends StatefulWidget {
  const PridavaniePsov({Key? key}) : super(key: key);

  @override
  _PridavaniePsov createState() => _PridavaniePsov();
}

class _PridavaniePsov extends State<PridavaniePsov> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        _hasPicture = true;
      } else {
        showSnackBar("No file selected", Duration(milliseconds: 400));
        _hasPicture = false;
      }
    });
  }

  var collection = FirebaseFirestore.instance.collection('dogs');
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future submitButton() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child(postID);
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    collection
        .doc(postID)
        .set({
          'name': name,
          'breed': breed,
          'ownerContact': ownerContact,
          'place': place,
          'time': time,
          'status': status,
          'postID': postID,
          'imgURL': downloadURL,
          'uid': globals.userUid
        })
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));

    _hasPicture = false;
    _hasPicture1 = false;
  }

  var name = '';
  var breed = '';
  var ownerContact = 0;
  var place = '';
  var time;
  var status = 'lost';
  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      _hasPicture = false;
                      _hasPicture1 = false;
                      Get.toNamed('/');
                    },
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.yellow[100],
                  title: Text(
                    'Fill out all the forms',
                    style: const TextStyle(
                        height: 2,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                body: Container(
                    padding: EdgeInsetsDirectional.only(top: 10),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _hasBeenPressed
                                      ? Colors.yellow[100]
                                      : Colors.lightGreen[50],
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20)),
                                  minimumSize: Size(94, 32)),
                              onPressed: () {
                                setState(() {
                                  _hasBeenPressed = true;
                                  status = 'lost';
                                });
                              },
                              child: const Text('Lost',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _hasBeenPressed
                                      ? Colors.lightGreen[50]
                                      : Colors.yellow[100],
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20)),
                                  minimumSize: Size(94, 32)),
                              onPressed: () {
                                setState(() {
                                  _hasBeenPressed = false;
                                  status = 'found';
                                });
                              },
                              child: const Text('Found',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(),
                          ]),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _hasPicture ? Colors.blue : Colors.grey,
                            ),
                            onPressed: () {
                              imagePickerMethod();
                            },
                            child: Container(
                                width: 275,
                                height: 50,
                                child: Icon(Icons.camera))),
                      ),
                      Form(
                          key: _formkey1,
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: 15, top: 40),
                                child: Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15, right: 5, top: 15),
                                          hintText: 'Name'),
                                      onChanged: (value) {
                                        name = value;
                                      },
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
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15, right: 5, top: 15),
                                          hintText: 'Breed'),
                                      onChanged: (value) {
                                        breed = value;
                                      },
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
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15, right: 5, top: 15),
                                          hintText: 'City/town'),
                                      onChanged: (value) {
                                        place = value;
                                      },
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
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15, right: 5, top: 15),
                                          hintText:
                                              'Your contact/phone number'),
                                      onChanged: (value) {
                                        ownerContact = int.parse(value);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ))),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: _hasPicture1
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now())
                                        .then((date) {
                                      if (date != null) {
                                        setState(() {
                                          time = date;
                                          print(time);
                                          _hasPicture1 = true;
                                        });
                                      } else {
                                        setState(() {
                                          time = null;
                                          print(time);
                                          _hasPicture1 = false;
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                      width: 275,
                                      height: 50,
                                      child: Icon(Icons.calendar_today))),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 30, bottom: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[100],
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30)),
                                      minimumSize: Size(110, 45)),
                                  onPressed: () {
                                    if (_hasPicture == true &&
                                        _hasPicture1 == true) {
                                      if (_formkey1.currentState!.validate()) {
                                        submitButton().whenComplete(() =>
                                            showSnackBar(
                                                "Post Uploaded Successfully",
                                                Duration(seconds: 2)));
                                        _formkey1.currentState!.reset();
                                        Get.toNamed('/');
                                      }
                                    }
                                    if (_hasPicture == false &&
                                        _hasPicture1 == true) {
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "NO PHOTO SELECTED",
                                        desc:
                                            "Please select a photo of your pet.",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Select",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () {
                                              if (_formkey1.currentState!
                                                  .validate()) {
                                                Navigator.pop(context);
                                                imagePickerMethod()
                                                    .whenComplete(
                                                        () => submitButton())
                                                    .whenComplete(() =>
                                                        showSnackBar(
                                                            "Post Uploaded Successfully",
                                                            Duration(
                                                                seconds: 2)));
                                                Get.toNamed('/');
                                                _formkey1.currentState!.reset();
                                              }
                                            },
                                            width: 120,
                                          )
                                        ],
                                      ).show();
                                    }
                                    if (_hasPicture == true &&
                                        _hasPicture1 == false) {
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "NO DATE SELECTED",
                                        desc:
                                            "Please select a date before submiting.",
                                      ).show();
                                    }
                                    if (_hasPicture == false &&
                                        _hasPicture1 == false) {
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "DATE AND IMAGE MISSING",
                                        desc:
                                            "Please select an aproximate date and an image before submiting.",
                                      ).show();
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black87),
                                  ),
                                )),
                          ])),
                    ]))))));
  }
}
