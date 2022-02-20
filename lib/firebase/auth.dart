import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_application_1/firebase/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:flutter_application_1/chat/userdatabase.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    globals.userUid = user.uid;

    Map<String, dynamic> userInfoMap = {
      "email": user.email,
      "uid": user.uid,
      "photoUrl": user.photoURL
    };
    String photo = '';
    globals.email1 = user.email!;
    if (user.photoURL == null) {
      photo = 'none';
    } else {
      photo = user.photoURL!;
    }
    globals.avi = photo;
    DatabaseMethods().addUserInfoToDB(user.uid, userInfoMap);
    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(credential.user);
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebase(credential.user);
  }

  Future<void> signOut1() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
