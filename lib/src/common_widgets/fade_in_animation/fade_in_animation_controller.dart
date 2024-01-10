import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart";


class FadeInAnimationController extends GetxController{
  static FadeInAnimationController get find=>Get.find();
  RxBool animate = false.obs;
  bool hasNavigated = false;

  Future startSplashAnimation() async {
    await Future.delayed(Duration(milliseconds: 100));
    animate.value = true;
    await Future.delayed(Duration(milliseconds: 3000));
    animate.value = false;
    await Future.delayed(Duration(milliseconds: 2000));
    //Get.offAll(() => const WelcomeScreen());

    if (!hasNavigated) {
      hasNavigated = true; // Mark navigation as completed
      Get.offAll(() => const WelcomeScreen());
    }
  }

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 100));
    animate.value = true;
  }
}