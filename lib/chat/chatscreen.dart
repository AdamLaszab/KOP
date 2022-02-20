import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/chat/userdatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/globals.dart' as globals;

class ChatScreen extends StatefulWidget {
  final String chatWithEmail;
  ChatScreen(this.chatWithEmail);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId = '', chatRoomId1 = '';
  Stream<QuerySnapshot>? messageStream;
  String? myEmail = globals.email1, myProfilePic = '';
  String messageId = '';
  TextEditingController messageTextEdittingController = TextEditingController();
  getMyInfo() async {
    myEmail = globals.email1;
    myProfilePic = globals.avi;
    chatRoomId = getChatRoomIdByUsername(myEmail!, widget.chatWithEmail);
    chatRoomId1 = getChatRoomIdByUsername(widget.chatWithEmail, myEmail!);
  }

  getChatRoomIdByUsername(String a, String b) {
    return "$a\_$b";
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;
      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myEmail,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      if (messageId == "") {
        messageId = DateTime.now().millisecondsSinceEpoch.toString();
      }
      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myEmail,
        };

        DatabaseMethods().updateLastMessageSent(chatRoomId, lastMessageInfoMap);

        if (messageId == "") {
          messageId = DateTime.now().millisecondsSinceEpoch.toString();
        }
        DatabaseMethods()
            .addMessage(chatRoomId1, messageId, messageInfoMap)
            .then((value) {
          Map<String, dynamic> lastMessageInfoMap = {
            "lastMessage": message,
            "lastMessageSendTs": lastMessageTs,
            "lastMessageSendBy": myEmail,
          };

          DatabaseMethods()
              .updateLastMessageSent(chatRoomId1, lastMessageInfoMap);

          if (sendClicked) {
            messageTextEdittingController.text = '';
            messageId = "";
          }
        });
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight:
                          sendByMe ? Radius.circular(0) : Radius.circular(24),
                      bottomLeft:
                          sendByMe ? Radius.circular(24) : Radius.circular(0),
                      topRight: Radius.circular(24)),
                  color: Colors.yellow[100]),
              padding: EdgeInsets.all(8),
              child: Text(
                message,
                style: TextStyle(fontSize: 18),
              )),
        ]);
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return chatMessageTile(
                      ds["message"], myEmail == ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() {
    getMyInfo();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed('/');
          },
        ),
        title: Text(
          widget.chatWithEmail,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.yellow[100],
      ),
      body: Container(
          child: Stack(
        children: [
          chatMessages(),
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
                      controller: messageTextEdittingController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                    )),
                    GestureDetector(
                        onTap: () {
                          addMessage(true);
                        },
                        child: Icon(Icons.send))
                  ],
                )),
          )
        ],
      )),
    );
  }
}
