import 'package:get/get.dart';

import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
import 'package:mausam/src/repository/authentication_repository/authentication_repository.dart';

class OTPController extends GetxController{
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async{
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.offAll(const HomePage()) : Get.back();
  }
}