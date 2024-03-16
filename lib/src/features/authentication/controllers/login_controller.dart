import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/authentication/models/user_model.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:mausam/src/repository/authentication_repository/authentication_repository.dart';
import 'package:mausam/src/repository/user_repository/user_repository.dart';

class LoginController extends GetxController{
  static LoginController get instance => Get.find();

  //final email = TextEditingController();
  //final password = TextEditingController();

  final userRepo = Get.put(UserRepository());

  /*void loginUser(String email, String password) {
    String? error = AuthenticationRepository.instance.loginWithEmailAndPassword(email, password) as String?;
    if(error != null){
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }*/
  void loginUser(String email, String password) async {
    UserModel? user = await userRepo.getUserDetails(email);
    if (user != null) {
      // Decrypt the stored password
      final decryptedPassword = user.getDecryptedPassword();
      if (decryptedPassword == password) {
        // Passwords match, proceed with login
        // Implement your login logic here
      } else {
        Get.showSnackbar(GetSnackBar(message: 'Invalid password'));
      }
    } else {
      Get.showSnackbar(GetSnackBar(message: 'User not found'));
    }
  }

/*Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
    phoneAuthentication(user.phoneNo);
    Get.to(()=>const OTPScreen());
  }

  void phoneAuthentication(String phoneNo){
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }*/
}