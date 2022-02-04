import 'package:flutter/material.dart';
import 'package:flutter_application_1/obrazovky/login_screen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/firebase/auth.dart';
import 'package:flutter_application_1/firebase/user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user == null ? LoginScreen() : LostFoundPage();
          } else {
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
