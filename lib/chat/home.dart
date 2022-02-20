import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat/chatscreen.dart';
import 'package:flutter_application_1/chat/userdatabase.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  Stream<QuerySnapshot>? usersStream;
  Stream<QuerySnapshot>? chatRoomsStream;
  String myEmail = '', myProfilePic = '';
  TextEditingController searchEmailEditingController = TextEditingController();
  getMyInfoFromSharedPreferences() {
    myEmail = globals.email1;
    myProfilePic = globals.avi;
  }

  onSearchButtonClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserByEmail(searchEmailEditingController.text);
    setState(() {});
  }

  getChatRoomIdByUsername(String a, String b) {
    return "$a\_$b";
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  Widget searchUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  String URL =
                      "https://pbs.twimg.com/media/C8QssPsVYAAHBfN.jpg";
                  return searchUser(URL, ds["email"]);
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchUser(String profileUrl, email) {
    return GestureDetector(
        onTap: () {
          myEmail = globals.email1;
          var chatRoomId = getChatRoomIdByUsername(myEmail, email);
          var chatRoomId1 = getChatRoomIdByUsername(email, myEmail);
          Map<String, dynamic> chatRoomInfoMap = {
            "users": [myEmail, email],
            "startUser": myEmail
          };
          Map<String, dynamic> chatRoomInfoMap1 = {
            "users": [email, myEmail],
            "startUser": email
          };
          DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
          DatabaseMethods().createChatRoom(chatRoomId1, chatRoomInfoMap1);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatScreen(email)));
        },
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(profileUrl, height: 40, width: 40)),
            SizedBox(width: 16),
            Text(email)
          ],
        ));
  }

  chatRoomsList() {
    return Container();
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreferences();
    getChatRooms();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
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
                  backgroundColor: Colors.yellow[100],
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Get.toNamed('/');
                    },
                  ),
                ),
                body: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Row(
                        children: [
                          isSearching
                              ? GestureDetector(
                                  onTap: () {
                                    isSearching = false;
                                    searchEmailEditingController.text = "";
                                    setState(() {});
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Icon(Icons.arrow_back)),
                                )
                              : Container(),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                    controller: searchEmailEditingController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "email"),
                                  )),
                                  GestureDetector(
                                      onTap: () {
                                        if (searchEmailEditingController.text !=
                                            "") {
                                          onSearchButtonClick();
                                        }
                                      },
                                      child: Icon(Icons.search))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      isSearching ? searchUsersList() : chatRoomsList()
                    ])))));
  }
}
