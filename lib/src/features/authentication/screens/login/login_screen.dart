import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:mausam/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:mausam/src/features/authentication/screens/login/login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeaderWidget(size: size),
                const LoginForm(),
                LoginFooterWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}




