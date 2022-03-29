import 'package:flutter_application_1/chat/home.dart';
import 'package:flutter_application_1/chat/push.dart';
import 'package:flutter_application_1/chat/recieved.dart';
import 'package:flutter_application_1/widgety/profil.dart';
import 'package:flutter_application_1/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/obrazovky/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/firebase/auth.dart';
import 'package:flutter_application_1/widgety/add_button.dart';
import 'package:get/get.dart';
import 'widgety/widget_list.dart';
import 'obrazovky/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_1/globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService();
  String? token = await FirebaseMessaging.instance.getToken();
  globals.deviceToken = token;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

Widget buildPetButton() => FloatingActionButton(
    child: Icon(
      Icons.pets,
      size: 35,
      color: Colors.black87,
    ),
    backgroundColor: Colors.yellow[100],
    onPressed: () {
      Get.off(() => PridavaniePsov());
    });

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
        ],
        child: GetMaterialApp(initialRoute: '/', routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => LoginScreen(),
        }));
  }
}

class LostFoundPage extends StatefulWidget {
  _LostFoundPageState createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      drawerScrimColor: Colors.yellow[100],
      endDrawer: Drawer(
          child: ListView(
        children: [
          ListTile(
              onTap: () {
                Get.off(() => Profil());
              },
              leading: Icon(
                Icons.account_circle,
                color: Colors.black87,
              ),
              trailing: Text(
                'Your posts',
                style: TextStyle(fontSize: 22, color: Colors.black87),
              )),
          ListTile(
              onTap: () {
                Get.off(() => Home());
              },
              leading: Icon(
                Icons.search,
                color: Colors.black87,
              ),
              trailing: Text(
                'Find user',
                style: TextStyle(fontSize: 22, color: Colors.black87),
              )),
          ListTile(
              onTap: () {
                Get.off(() => ChatRoomList());
              },
              leading: Icon(
                Icons.chat_bubble,
                color: Colors.black87,
              ),
              trailing: Text(
                'Incoming messages',
                style: TextStyle(fontSize: 22, color: Colors.black87),
              )),
          ListTile(
              onTap: () async {
                await authService.signOut1();
                await authService.signOutFromGoogle();
              },
              leading: Icon(
                Icons.logout,
                color: Colors.black87,
              ),
              trailing: Text(
                'Signout',
                style: TextStyle(fontSize: 22, color: Colors.black87),
              ))
        ],
      )),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
              iconTheme: IconThemeData(color: Colors.black87),
              centerTitle: true,
              backgroundColor: Colors.yellow[100],
              title: Text(
                'Nearby',
                style: const TextStyle(
                    height: 2,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ))),
      body: Container(
          padding: EdgeInsetsDirectional.only(top: 10),
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Container(), Container()]),
            Expanded(child: HlavnyListView())
          ])),
      floatingActionButton:
          SizedBox(height: 80, width: 80, child: buildPetButton()),
    );
  }
}
