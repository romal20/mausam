// Import necessary packages and files
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
import 'package:mausam/src/features/authentication/screens/login/login_screen.dart';

// Screen for sending a password reset email
class ForgotPasswordMailScreen extends StatefulWidget {
  const ForgotPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordMailScreen> createState() => _ForgotPasswordMailScreenState();
}

class _ForgotPasswordMailScreenState extends State<ForgotPasswordMailScreen> {
  // Controller for the email input field
  final emailController = TextEditingController();

  // Dispose of the email controller when the screen is disposed
  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  // Build the UI for the screen
  @override
  Widget build(BuildContext context) {
    // Check if the app is in dark mode
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Scaffold widget with app bar and body
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          // Navigate back to the LoginScreen when the back button is pressed
          onPressed: () {
            Get.offAll(() => LoginScreen());
          },
          icon: const Icon(LineAwesomeIcons.arrow_left, size: 32),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children: [
              SizedBox(height: defaultSize*4),
              // Header for the form
              FormHeaderWidget(
                image: forgotPasswordImage,
                title: forgotPassword,
                subTitle: forgotPasswordSubTitle,
                crossAxisAlignment: CrossAxisAlignment.center,
                heightBetween: 30.0,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0,),
              // Form for entering email
              Form(
                child: Column(
                  children: [
                    // Text form field for entering email
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
                    // Button to reset password
                    SizedBox(width: double.infinity, child: ElevatedButton(
                      onPressed: resetPassword,
                      child: Text("Next"),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to reset the password
  Future resetPassword() async{
    // Show a loading dialog while resetting password
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

    try {
      // Send a password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      // Show a success snackbar
      Get.snackbar("Password Reset Email Sent",
          "Please check your email to reset your password.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
      // Navigate back to the first screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch(e){
      // Show an error snackbar
      Get.snackbar("" , e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      Navigator.of(context).pop();
    }
  }
}
