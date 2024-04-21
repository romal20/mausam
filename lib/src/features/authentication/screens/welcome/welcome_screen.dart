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
    final controller = Get.put(FadeInAnimationController()); // Initialize fade-in animation controller
    controller.startAnimation(); // Start fade-in animation

    var mediaQuery = MediaQuery.of(context); // Get media query for screen dimensions
    var height = mediaQuery.size.height; // Get screen height
    var brightness = mediaQuery.platformBrightness; // Get screen brightness mode
    final isDarkMode = brightness == Brightness.dark; // Check if dark mode is enabled

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white, // Set background color based on dark mode
        body: Stack(
          children: [
            // Fade-in animation for main content
            FadeInAnimation(
              durationInMs: 1200,
              animate: tAnimatePosition(
                bottomAfter: 0,
                bottomBefore: -100,
                leftBefore: 0,
                leftAfter: 0,
                rightBefore: 0,
                rightAfter: 0,
                topBefore: 0,
                topAfter: 0,
              ),
              child: Container(
                padding: EdgeInsets.all(defaultSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(welcomeScreenImage, width: 600, height: height * 0.6), // Display welcome image
                    Column(
                      children: [
                        Text(welcomeTitle, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), // Display welcome title
                        Text(welcomeSubTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300), textAlign: TextAlign.center), // Display welcome subtitle
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.to(() => LoginScreen()), // Navigate to login screen on button press
                            child: Text("LOGIN"), // Button text
                          ),
                        ),
                        SizedBox(width: 10), // Spacer
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.to(() => SignUpScreen()), // Navigate to signup screen on button press
                            child: Text("SIGN UP"), // Button text
                          ),
                        ),
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