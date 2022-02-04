import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:intl/intl.dart';

class Profil extends StatefulWidget {
  @override
  _Profil createState() => _Profil();
}

class _Profil extends State<Profil> {
  Stream<QuerySnapshot> dogs = FirebaseFirestore.instance
      .collection('dogs')
      .where('uid', isEqualTo: globals.userUid)
      .snapshots();
  final collection = FirebaseFirestore.instance.collection('dogs');
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
                      Get.toNamed('/');
                    },
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.yellow[100],
                  title: Text(
                    'Your posts ',
                    style: const TextStyle(
                        height: 2,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                body: SingleChildScrollView(
                    child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: dogs,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong.');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading');
                          }
                          final data = snapshot.requireData;
                          return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.size,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: 160,
                                  child: Stack(children: [
                                    Positioned(
                                        left: 50,
                                        top: 20,
                                        child: Text(data.docs[index]['name'],
                                            style: const TextStyle(
                                                height: 2,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87))),
                                    Positioned(
                                        top: 110,
                                        left: 80,
                                        child: Row(children: [
                                          Icon(Icons.access_time_rounded),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6.5, right: 5),
                                              child: Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(data.docs[index]
                                                              ['time']
                                                          .toDate()),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87))),
                                        ])),
                                    Positioned(
                                        top: 65,
                                        left: 110,
                                        child: Text(data.docs[index]['place'],
                                            style: const TextStyle(
                                                height: 2,
                                                fontSize: 18,
                                                color: Colors.black87))),
                                    Positioned(
                                        top: 75,
                                        left: 80,
                                        child: Icon(Icons.location_on)),
                                    Positioned(
                                        top: 20,
                                        left: 215,
                                        child: Container(
                                            width: 160,
                                            height: 135,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                    data.docs[index]['imgURL'],
                                                    fit: BoxFit.cover)))),
                                    Positioned(
                                      top: 26,
                                      left: 45,
                                      child: Container(
                                          width: 170,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)))),
                                    ),
                                    Positioned(
                                        top: 12,
                                        left: 320,
                                        child: Transform.scale(
                                            scale: 1.7,
                                            child: IconButton(
                                              padding: EdgeInsets.only(top: 5),
                                              onPressed: () {
                                                Get.dialog(Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .all(
                                                                new Radius
                                                                        .circular(
                                                                    30))),
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Container(
                                                        height: 320,
                                                        width: 150,
                                                        child: Stack(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              Positioned(
                                                                  top: 115,
                                                                  child: Icon(
                                                                    Icons.pets,
                                                                    size: 170,
                                                                    color: Colors
                                                                            .yellow[
                                                                        100],
                                                                  )),
                                                              Positioned(
                                                                  top: -45,
                                                                  child: Container(
                                                                      height:
                                                                          140,
                                                                      width:
                                                                          140,
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                              600),
                                                                          child: Image.network(
                                                                              data.docs[index]['imgURL'],
                                                                              fit: BoxFit.cover)))),
                                                              Positioned(
                                                                  left: 30,
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 95)),
                                                                        Text('Name: ' + data.docs[index]['name'],
                                                                            style: const TextStyle(
                                                                                fontSize: 19,
                                                                                height: 1.9,
                                                                                color: Colors.black87)),
                                                                        Text('Breed: ' + data.docs[index]['breed'],
                                                                            style: const TextStyle(
                                                                                fontSize: 19,
                                                                                height: 1.9,
                                                                                color: Colors.black87)),
                                                                        Text('Town: ' + data.docs[index]['place'],
                                                                            style: const TextStyle(
                                                                                fontSize: 19,
                                                                                height: 1.9,
                                                                                color: Colors.black87)),
                                                                        Text('Upload time: ' + DateFormat('dd-MM-yyyy').format(data.docs[index]['time'].toDate()),
                                                                            style: const TextStyle(
                                                                                fontSize: 19,
                                                                                height: 1.9,
                                                                                color: Colors.black87)),
                                                                        Text('Ownercontact: ' + data.docs[index]['ownerContact'].toString(),
                                                                            style: const TextStyle(
                                                                                fontSize: 19,
                                                                                height: 1.9,
                                                                                color: Colors.black87)),
                                                                        Text('Status: ' + data.docs[index]['status'],
                                                                            style: const TextStyle(
                                                                                fontSize: 19,
                                                                                height: 1.9,
                                                                                color: Colors.black87)),
                                                                      ]))
                                                            ]))));
                                              },
                                              icon: Icon(
                                                Icons.more_horiz,
                                                color: Colors.white,
                                              ),
                                            ))),
                                    Positioned(
                                        left: 320,
                                        top: 100,
                                        child: Transform.scale(
                                            scale: 1.7,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete_rounded,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                print(
                                                    data.docs[index]['postID']);
                                                collection
                                                    .doc(data.docs[index]
                                                        ['postID'])
                                                    .delete()
                                                    .then(
                                                        (_) => print('Deleted'))
                                                    .catchError((error) => print(
                                                        'Delete failed: $error'));
                                              },
                                            )))
                                  ]));
                            },
                          );
                        })
                  ],
                )))));
  }
}
