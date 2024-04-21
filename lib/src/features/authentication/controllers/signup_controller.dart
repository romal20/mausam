import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/authentication/models/user_model.dart';
import 'package:mausam/src/repository/user_repository/user_repository.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';

class SignUpController extends GetxController {
  // Get instance of the SignUpController
  static SignUpController get instance => Get.find();

  // Text editing controllers for email, password, and full name
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  //final phoneNo = TextEditingController(); // Uncomment this line if needed

  // User repository instance for handling user data
  final userRepo = Get.put(UserRepository());

  // Method for registering a user with email and password
  void registerUser(String email, String password) {
    // Attempt to create a user with the provided email and password
    String? error =
    AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password) as String?;
    if (error != null) {
      // Show a snackbar with the error message if registration fails
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }
}
