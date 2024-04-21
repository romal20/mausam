import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/signup/signup_screen.dart';

// Widget for the footer of the login screen
class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10.0),
        // Text prompting to sign up if user doesn't have an account
        Center(
          child: TextButton(
            onPressed: () {
              // Navigate to the sign up screen
              Get.off(() => SignUpScreen());
            },
            child: Text.rich(
              TextSpan(
                text: dontHaveAnAccount,
                style: Theme.of(context).textTheme.bodyText1,
                children: const [
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
