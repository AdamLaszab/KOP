import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:flutter_application_1/chat/chatscreen.dart';
import 'package:flutter_application_1/chat/userdatabase.dart';

class HlavnyListView extends StatefulWidget {
  @override
  _HlavnyListState createState() => _HlavnyListState();
}

bool _hasBeenPressed = true;
getChatRoomIdByUsername(String a, String b) {
  return "$a\_$b";
}

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
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.20,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                    left: MediaQuery.of(context).size.width *
                                        0.02),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.docs[index]['name'],
                                        style: const TextStyle(
                                            height: 1,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.008,
                                        ),
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
                                                      fontSize: 16,
                                                      color: Colors.black87))),
                                        ]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.008),
                                        child: Row(children: [
                                          Icon(Icons.location_on),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6.5, right: 5),
                                              child: Text(
                                                  data.docs[index]["place"],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87))),
                                        ]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                        child: Row(children: [
                                          Icon(Icons.pets),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6.5, right: 5),
                                              child: Text(
                                                  data.docs[index]["breed"],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87))),
                                        ]),
                                      )
                                    ]),
                              ),
                            ),
                            Stack(children: [
                              Container(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                          data.docs[index]['imgURL'],
                                          fit: BoxFit.cover)),
                                  height:
                                      MediaQuery.of(context).size.height * 0.23,
                                  width:
                                      MediaQuery.of(context).size.width * 0.47),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.34,
                                child: Transform.scale(
                                    scale: MediaQuery.of(context).size.width *
                                        0.006,
                                    child: IconButton(
                                      padding: EdgeInsets.only(top: 5),
                                      onPressed: () {
                                        Get.dialog(Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    new Radius.circular(30))),
                                            backgroundColor: Colors.white,
                                            child: Container(
                                                height: 500,
                                                width: 150,
                                                child: Stack(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Positioned(
                                                          top: 115,
                                                          child: Icon(
                                                            Icons.pets,
                                                            size: 170,
                                                            color: Colors
                                                                .yellow[100],
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
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 95)),
                                                              Text(
                                                                  'Name: ' +
                                                                      data.docs[
                                                                              index]
                                                                          [
                                                                          'name'],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          19,
                                                                      height:
                                                                          1.9,
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
                                                                      height:
                                                                          1.9,
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
                                                                      height:
                                                                          1.9,
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
                                                                      height:
                                                                          1.9,
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
                                                                      height:
                                                                          1.9,
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
                                                                      height:
                                                                          1.9,
                                                                      color: Colors
                                                                          .black87)),
                                                            ]),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                primary: Colors
                                                                        .yellow[
                                                                    100],
                                                                shape: new RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        new BorderRadius.circular(
                                                                            30))),
                                                            onPressed: () {
                                                              var chatRoomId =
                                                                  getChatRoomIdByUsername(
                                                                      globals
                                                                          .email1,
                                                                      data.docs[
                                                                              index]
                                                                          [
                                                                          'email']);
                                                              var chatRoomId1 =
                                                                  getChatRoomIdByUsername(
                                                                      data.docs[
                                                                              index]
                                                                          [
                                                                          'email'],
                                                                      globals
                                                                          .email1);
                                                              Map<String,
                                                                      dynamic>
                                                                  chatRoomInfoMap =
                                                                  {
                                                                "users": [
                                                                  globals
                                                                      .email1,
                                                                  data.docs[
                                                                          index]
                                                                      ['email']
                                                                ],
                                                                "startUser":
                                                                    globals
                                                                        .email1
                                                              };
                                                              Map<String,
                                                                      dynamic>
                                                                  chatRoomInfoMap1 =
                                                                  {
                                                                "users": [
                                                                  data.docs[
                                                                          index]
                                                                      ['email'],
                                                                  globals.email1
                                                                ],
                                                                "startUser":
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'email']
                                                              };
                                                              DatabaseMethods()
                                                                  .createChatRoom(
                                                                      chatRoomId,
                                                                      chatRoomInfoMap);
                                                              DatabaseMethods()
                                                                  .createChatRoom(
                                                                      chatRoomId1,
                                                                      chatRoomInfoMap1);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChatScreen(data.docs[index]
                                                                              [
                                                                              'email'])));
                                                            },
                                                            child: Container(
                                                                child: Text(
                                                              "Message User in App",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87),
                                                            ))),
                                                      )
                                                    ]))));
                                      },
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ])
                          ]);
                    },
                    separatorBuilder: (context, position) {
                      return Container(height: 20);
                    },
                  )
                ]);
          }));
}
