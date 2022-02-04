import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .snapshots();
  }
}
