import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat/helper.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithEmail;
  ChatScreen(this.chatWithEmail);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId = '';
  String? myEmail = '', myProfilePic = '';

  getMyInfoFromSharedPreferences() async {
    myEmail = await SharedPreferenceHelper().getUseremail();
    myProfilePic = await SharedPreferenceHelper().getProfile();

    chatRoomId = getChatRoomIdByUsername(widget.chatWithEmail, myEmail!);
  }

  getChatRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getAndSetMessages() async {}

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreferences();
    getAndSetMessages();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatWithEmail,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.yellow[100],
      ),
      body: Container(
          child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                    )),
                    Icon(Icons.send)
                  ],
                )),
          )
        ],
      )),
    );
  }
}
