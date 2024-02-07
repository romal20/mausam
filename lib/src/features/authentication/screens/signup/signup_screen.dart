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
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              children: [
                const FormHeaderWidget(image: welcomeScreenImage, title: signUpTitle, subTitle: signUpSubTitle),
                SignUpFormWidget(),
                Column(
                  children: [
                    //const Text("OR"),
                    const SizedBox(height: 10.0),
                    /*SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(onPressed: (){
                      }, icon: const Image(image: AssetImage(GoogleLogoImage),width: 20.0,),
                          label: const Text(SignInWithGoogle)),
                    ),
                    const SizedBox(height: 10.0,),*/
                    TextButton(onPressed: (){
                      Get.offAll(() => LoginScreen());
                    }, child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: alreadyHaveAnAccount,style: Theme.of(context).textTheme.bodyLarge),
                        TextSpan(text: "Login",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600)),
                      ]
                    )))
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}


