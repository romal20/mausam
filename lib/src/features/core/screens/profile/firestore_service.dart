import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../authentication/models/user_model.dart'; // Import your UserModel

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String, dynamic>> userData = await _firestore.collection('users').doc(user?.uid).get();
    return UserModel.fromSnapshot(userData);

  }
}
