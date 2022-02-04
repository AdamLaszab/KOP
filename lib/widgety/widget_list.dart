import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:intl/intl.dart';

class HlavnyListView extends StatefulWidget {
  @override
  _HlavnyListState createState() => _HlavnyListState();
}

bool _hasBeenPressed = true;

class _HlavnyListState extends State<HlavnyListView> {
  Stream<QuerySnapshot> dogs = FirebaseFirestore.instance
      .collection('dogs')
      .where('status', isEqualTo: 'lost')
      .snapshots();
  Stream<QuerySnapshot> dogs1 = FirebaseFirestore.instance
      .collection('dogs')
      .where('status', isEqualTo: 'found')
      .snapshots();
  Widget build(BuildContext context) => SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: globals.state1 ? dogs : dogs1,
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text('Something went wrong.');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            }
            final data = snapshot.requireData;
            print('Widget was built');
            return Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _hasBeenPressed
                            ? Colors.yellow[100]
                            : Colors.lightGreen[50],
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                        minimumSize: Size(94, 32)),
                    onPressed: () {
                      globals.state1 = true;
                      print(globals.state1);
                      setState(() {
                        _hasBeenPressed = true;
                      });
                    },
                    child: const Text('Lost',
                        style: TextStyle(color: Colors.black87)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _hasBeenPressed
                            ? Colors.lightGreen[50]
                            : Colors.yellow[100],
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                        minimumSize: Size(94, 32)),
                    onPressed: () {
                      globals.state1 = false;
                      print(globals.state1);
                      setState(() {
                        _hasBeenPressed = false;
                      });
                    },
                    child: const Text(
                      'Found',
                      style: TextStyle(color: Colors.black87),
                    ),
                  )
                ],
              ),
              ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Container(
                      height: 160,
                      child: Stack(children: [
                        Positioned(
                            left: 30,
                            top: 20,
                            child: Text(data.docs[index]['name'],
                                style: const TextStyle(
                                    height: 2,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87))),
                        Positioned(
                            top: 110,
                            left: 60,
                            child: Row(children: [
                              Icon(Icons.access_time_rounded),
                              Padding(
                                  padding: EdgeInsets.only(left: 6.5, right: 5),
                                  child: Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          data.docs[index]['time'].toDate()),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87))),
                            ])),
                        Positioned(
                            top: 65,
                            left: 90,
                            child: Text(data.docs[index]['place'],
                                style: const TextStyle(
                                    height: 2,
                                    fontSize: 18,
                                    color: Colors.black87))),
                        Positioned(
                            top: 75, left: 60, child: Icon(Icons.location_on)),
                        Positioned(
                            top: 20,
                            left: 195,
                            child: Container(
                                width: 160,
                                height: 135,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                        data.docs[index]['imgURL'],
                                        fit: BoxFit.cover)))),
                        Positioned(
                          top: 26,
                          left: 25,
                          child: Container(
                              width: 170,
                              height: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                        ),
                        Positioned(
                            top: 12,
                            left: 300,
                            child: Transform.scale(
                                scale: 1.7,
                                child: IconButton(
                                  padding: EdgeInsets.only(top: 5),
                                  onPressed: () {
                                    Get.dialog(Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(30))),
                                        backgroundColor: Colors.white,
                                        child: Container(
                                            height: 320,
                                            width: 150,
                                            child: Stack(
                                                alignment: Alignment.topCenter,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Positioned(
                                                      top: 115,
                                                      child: Icon(
                                                        Icons.pets,
                                                        size: 170,
                                                        color:
                                                            Colors.yellow[100],
                                                      )),
                                                  Positioned(
                                                      top: -45,
                                                      child: Container(
                                                          height: 140,
                                                          width: 140,
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          600),
                                                              child: Image.network(
                                                                  data.docs[
                                                                          index]
                                                                      [
                                                                      'imgURL'],
                                                                  fit: BoxFit
                                                                      .cover)))),
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
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            95)),
                                                            Text(
                                                                'Name: ' +
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    height: 1.9,
                                                                    color: Colors
                                                                        .black87)),
                                                            Text(
                                                                'Breed: ' +
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'breed'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    height: 1.9,
                                                                    color: Colors
                                                                        .black87)),
                                                            Text(
                                                                'Town: ' +
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'place'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    height: 1.9,
                                                                    color: Colors
                                                                        .black87)),
                                                            Text(
                                                                'Upload time: ' +
                                                                    DateFormat('dd-MM-yyyy').format(data
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'time']
                                                                        .toDate()),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    height: 1.9,
                                                                    color: Colors
                                                                        .black87)),
                                                            Text(
                                                                'Ownercontact: ' +
                                                                    data.docs[
                                                                            index]
                                                                            [
                                                                            'ownerContact']
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    height: 1.9,
                                                                    color: Colors
                                                                        .black87)),
                                                            Text(
                                                                'Status: ' +
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'status'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    height: 1.9,
                                                                    color: Colors
                                                                        .black87)),
                                                          ]))
                                                ]))));
                                  },
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ),
                                )))
                      ]));
                },
              )
            ]);
          }));
}
