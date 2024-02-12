import "dart:async";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mausam/src/common_widgets/fade_in_animation/animation_design.dart";
import "package:mausam/src/common_widgets/fade_in_animation/fade_in_animation_model.dart";
import "package:mausam/src/constants/colors.dart";
import "package:mausam/src/constants/image_strings.dart";
import "package:mausam/src/constants/sizes.dart";
import "package:mausam/src/constants/text_strings.dart";
import 'package:mausam/src/common_widgets/fade_in_animation/fade_in_animation_controller.dart';
import "package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart";
import "package:mausam/src/features/core/screens/dashboard/home_page.dart";
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
      return new Timer(_duration, navigationPageHome);
    } else {// First time
      prefs.setBool('first_time', false);
      return new Timer(_duration, navigationPageWel);
    }
  }

  void navigationPageHome() {
    Get.offAll(() => HomePage());
//    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  void navigationPageWel() {
    Get.offAll(() => WelcomeScreen());
  //  Navigator.of(context).pushReplacementNamed('/WelcomePage');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startSplashAnimation();
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff10012a) : Colors.white,
      body: Stack(
        children: [
          FadeInAnimation(
            durationInMs: 1600,
            animate: tAnimatePosition(topAfter: -20, topBefore: -60, leftBefore: -60, leftAfter: -20),
            child: Image.network(splashTopIcon,width: 100,height: 100),
          ),
          FadeInAnimation(
            durationInMs: 2000,
            animate: tAnimatePosition(topBefore: 80, topAfter: 80, leftAfter: defaultSize, leftBefore: -80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 50, height: 50,),
                Text(appName, textAlign: TextAlign.center, style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Colors.blue[800])), //fontSize: 60
                Text(appTagLine, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.blue[700])),     //fontSize: 26
              ],
            ),
    ),
        FadeInAnimation(
          durationInMs: 2400,
          animate: tAnimatePosition(bottomBefore: 0,bottomAfter: 100),
          child: Center(child: Image.network(splashImage,width: 400,height: 450,)),
        ),
          FadeInAnimation(
            durationInMs: 2400,
            animate: tAnimatePosition(bottomBefore: 0, bottomAfter: 60, rightBefore: defaultSize, rightAfter: defaultSize),
            child: Container(
                width: splashContainerSize,
                height: splashContainerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blue[800])
              ),
          ),
      ],
      ),
    );
  }
}


