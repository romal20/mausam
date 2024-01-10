import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/signup/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //const Text("OR"),
        const SizedBox(height: 10.0),
        /*SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
              icon: Image(image: AssetImage(GoogleLogoImage),width: 20,height: 25),
              onPressed: (){},
              label: Text(SignInWithGoogle)),
        ),
        const SizedBox(height: 10.0,),*/
        Center(
          child: TextButton(onPressed: (){
            Get.off(() => SignUpScreen());
          }, child: Text.rich(TextSpan(
              text: dontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyLarge,
              children: const[
                TextSpan(
                  text: "Sign Up",
                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),
                )
              ]
          ))),
        )
      ],
    );
  }
}