import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:mausam/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:mausam/src/features/authentication/screens/login/login_header_widget.dart';

// Screen for the login page
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    // Check if the current theme mode is dark
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        // Set the background color based on the theme mode
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section of the login screen
                LoginHeaderWidget(size: size),
                // Form section of the login screen
                const LoginForm(),
                // Footer section of the login screen
                LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
