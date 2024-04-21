import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/common_widgets/form/form_header_widget.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/login/login_screen.dart';
import 'package:mausam/src/features/authentication/screens/signup/widgets/signup_form_widget.dart';
import 'package:mausam/src/repository/authentication_repository/authentication_repository.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark; // Check if dark mode is enabled

    // Scaffold widget for the sign-up screen
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white, // Set background color based on dark mode
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize), // Set padding for the container
            child: Column(
              children: [
                // Form header widget
                const FormHeaderWidget(
                  image: welcomeScreenImage, // Image for the form header
                  title: signUpTitle, // Title for the form header
                  subTitle: signUpSubTitle, // Subtitle for the form header
                ),
                SignUpFormWidget(), // Sign-up form widget
                Column(
                  children: [
                    // 'OR' text
                    //const Text("OR"),
                    const SizedBox(height: 10.0), // Empty space
                    /*SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(onPressed: (){
                      }, icon: const Image(image: AssetImage(GoogleLogoImage),width: 20.0,),
                          label: const Text(SignInWithGoogle)),
                    ),
                    const SizedBox(height: 10.0,),*/
                    // Login button
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => LoginScreen()); // Navigate to login screen
                      },
                      child: Text.rich(TextSpan(
                        children: [
                          TextSpan(text: alreadyHaveAnAccount, style: Theme.of(context).textTheme.bodyLarge), // Text for already have an account
                          TextSpan(text: "Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)), // Text for login
                        ],
                      )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


