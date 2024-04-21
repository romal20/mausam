import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/authentication/models/user_model.dart';

// UserRepository class for handling user-related operations
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();  // GetX instance for UserRepository
  final _db = FirebaseFirestore.instance;  // Firestore instance

  // Method to create a new user in Firestore
  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson()).whenComplete(
            () => Get.snackbar("Success", "Your account has been created.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green))
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }

  // Method to get user details from Firestore based on email
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  // Method to get all users from Firestore
  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  // Method to update user record in Firestore
  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson());
  }
}

// CityRepository class for handling city-related operations
class CityRepository extends GetxController {
  static UserRepository get instance => Get.find();  // GetX instance for CityRepository
  final _db = FirebaseFirestore.instance;  // Firestore instance

  final user = FirebaseAuth.instance.currentUser;  // Firebase current user
  final userId = FirebaseAuth.instance.currentUser?.uid;  // Firebase current user ID

  // Method to create a new city record in Firestore for a specific user
  createUser(CityModel cities) async {
    await _db.collection("Users").doc(userId).collection("selected_cities")
        .add(cities.toJson()).whenComplete(
            () =>
            Get.snackbar("Success", "Your cities have been added.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green))
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }
}