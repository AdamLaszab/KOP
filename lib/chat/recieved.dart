// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat/chatscreen.dart';
import 'package:flutter_application_1/chat/userdatabase.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/globals.dart' as globals;

class ChatRoomList extends StatefulWidget {
  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  Stream<QuerySnapshot>? chatRoomsStream;
  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    getChatRooms();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
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
          child: StreamBuilder<QuerySnapshot>(
            stream: chatRoomsStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        bool whoSent = true;
                        if (ds["lastMessageSendBy"] == globals.email1) {
                          whoSent = false;
                        } else {
                          whoSent = true;
                        }
                        return ChatRoomListTile(
                            ds["lastMessage"], whoSent, ds.id, globals.email1);
                      })
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myEmail;
  bool whoSent;
  ChatRoomListTile(
      this.lastMessage, this.whoSent, this.chatRoomId, this.myEmail);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "https://pbs.twimg.com/media/C8QssPsVYAAHBfN.jpg",
      email = "",
      email1 = "";
  getThisUserInfo() async {
    email1 =
        widget.chatRoomId.replaceAll(widget.myEmail, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(email1);
    email = "${querySnapshot.docs[0]["email"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(email1)));
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profilePicUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  widget.lastMessage,
                  style: TextStyle(
                      color: widget.whoSent ? Colors.red[400] : Colors.black87),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
