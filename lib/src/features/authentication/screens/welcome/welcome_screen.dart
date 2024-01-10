import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/common_widgets/fade_in_animation/animation_design.dart';
import 'package:mausam/src/common_widgets/fade_in_animation/fade_in_animation_controller.dart';
import 'package:mausam/src/common_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/login/login_screen.dart';
import 'package:mausam/src/features/authentication/screens/signup/signup_screen.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startAnimation();

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        //backgroundColor: isDarkMode ? SecondaryColor : welcomeLight,
        body: Stack(
          children: [
            FadeInAnimation(
              durationInMs: 1200,
              animate: tAnimatePosition(bottomAfter: 0,bottomBefore: -100,leftBefore: 0,leftAfter: 0,
                  rightBefore: 0,rightAfter: 0,topBefore: 0,topAfter: 0),
              child: Container(
                padding: EdgeInsets.all(defaultSize),
                /*decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.lightBlueAccent,
                      Colors.white,
                    Colors.lightBlueAccent,
                      //Color(0xFF05255E,)
                    ]
                  )
                ),*/
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(image: AssetImage(welcomeScreenImage),width: 600,height: height*0.6),
                    Column(
                      children: [
                        Text(welcomeTitle,style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold)),  //fontSize: 28
                        Text(welcomeSubTitle,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(
                            onPressed: () => Get.to(() => LoginScreen()),
                            child: Text("LOGIN"))),
                        SizedBox(width: 10),
                        Expanded(child: ElevatedButton(
                            onPressed: () => Get.to(() => SignUpScreen()),
                            child: Text("SIGN UP"))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
