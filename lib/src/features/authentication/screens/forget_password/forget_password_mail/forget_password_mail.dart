import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mausam/src/common_widgets/form/form_header_widget.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:mausam/src/features/authentication/screens/login/login_screen.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordMailScreen> createState() => _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final emailController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          //automaticallyImplyLeading: true,
          leading: IconButton(onPressed: (){Get.offAll(() => LoginScreen());},
              icon: const Icon(LineAwesomeIcons.arrow_left,size: 32)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              children: [
                SizedBox(height: defaultSize*4),
                FormHeaderWidget(
                  image: forgetPasswordImage,
                  title: forgetPassword,
                  subTitle: forgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween:30.0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0,),
                Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            EmailValidator(errorText: "Enter valid email-id"),
                          ]),
                          decoration: InputDecoration(
                            label: Text(Email),
                            hintText: Email,
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 20.0,),
                        SizedBox(width: double.infinity, child: ElevatedButton(
                            onPressed: resetPassword,
                            child: Text("Next")))
                      ],
                    )
                )
              ],
            ),
          ),
        ),

    );
  }

  Future resetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      Get.snackbar("Password Reset Email Sent",
          "Please check your email to reset your password.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch(e){
      print(e);
      Get.snackbar("" , e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
      Navigator.of(context).pop();
    }
  }
}
