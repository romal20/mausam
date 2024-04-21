import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/authentication/controllers/signup_controller.dart';
import 'package:mausam/src/features/authentication/models/user_model.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
import 'package:mausam/src/repository/authentication_repository/authentication_repository.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
  });

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  String Country = ''; // Variable to store the country code
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Global key for the form
  var authController = Get.put(AuthController()); // GetX controller for authentication
  bool _isSecurePassword = true; // Variable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController()); // GetX controller for sign-up

    // Container containing the sign-up form
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        key: _formKey, // Assigning the form key
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name TextFormField
            TextFormField(
              controller: controller.fullName, // Assigning the controller for full name
              validator: MultiValidator([ // Validator for full name
                RequiredValidator(errorText: "* Required"), // Required validator
                MinLengthValidator(3, errorText: 'Name should be at least 3 characters'), // Min length validator
                MaxLengthValidator(30, errorText: 'Name should not exceed 30 characters'), // Max length validator
                PatternValidator(r'^[a-zA-Z\s]+$', errorText: 'Please enter a valid name'), // Pattern validator
              ]),
              decoration: const InputDecoration(
                label: Text("Full Name"), // Label for full name field
                prefixIcon: Icon(Icons.person_outline_rounded), // Prefix icon for full name field
              ),
            ),
            const SizedBox(height: 20.0), // Empty space
            // Email TextFormField
            TextFormField(
              controller: controller.email, // Assigning the controller for email
              validator: MultiValidator([ // Validator for email
                RequiredValidator(errorText: "* Required"), // Required validator
                EmailValidator(errorText: "Enter valid Email Id"), // Email validator
              ]),
              decoration: const InputDecoration(
                label: Text("Email"), // Label for email field
                prefixIcon: Icon(Icons.email_outlined), // Prefix icon for email field
              ),
            ),
            const SizedBox(height: 20.0), // Empty space
            // Password TextFormField
            TextFormField(
              controller: controller.password, // Assigning the controller for password
              obscureText: _isSecurePassword, // Toggling password visibility
              validator: MultiValidator([ // Validator for password
                RequiredValidator(errorText: "* Required"), // Required validator
                MinLengthValidator(6, errorText: "Password should be at least 6 characters"), // Min length validator
                MaxLengthValidator(15, errorText: "Password should not be greater than 15 characters"), // Max length validator
              ]),
              decoration: InputDecoration(
                label: Text("Password"), // Label for password field
                prefixIcon: Icon(Icons.fingerprint), // Prefix icon for password field
                suffixIcon: togglePassword(), // Toggle icon for password visibility
              ),
            ),
            const SizedBox(height: 30.0), // Empty space
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Sign-up method call
                      await authController.signUpMethod(
                        email: controller.email.text.trim(), // Trimming and passing email
                        password: controller.password.text.trim(), // Trimming and passing password
                        context: context, // Passing context
                      ).then((value) {
                        // Storing user data
                        return authController.storeUserData(
                          controller.fullName.text, // Passing full name
                          controller.email.text, // Passing email
                          controller.password.text, // Passing password
                        );
                      }).then((value) {
                        // Showing success message and navigating to home page
                        Get.snackbar("Success", "Signed In Successfully.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            colorText: Colors.green);
                        Get.offAll(() => HomePage()); // Navigating to home page
                      });
                    } catch (e) {
                      FirebaseAuth.instance.signOut(); // Signing out of Firebase
                      Get.snackbar("Error", e.toString()); // Showing error message
                    }
                  }
                },
                child: Text("SIGN UP"), // Button text
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to toggle password visibility
  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword; // Toggling password visibility
        });
      },
      icon: _isSecurePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), // Icon based on password visibility
      color: Colors.grey, // Icon color
    );
  }

  // Future method to verify email
  Future verifyEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Sending email verification
      await FirebaseAuth.instance.currentUser?.sendEmailVerification().whenComplete(() =>
          Get.snackbar("Verification Email Sent",
              "Please check your email to verify your email.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white)
      );
      Navigator.of(context).popUntil((route) => route.isFirst); // Pop until first route
    } on FirebaseAuthException catch(e) {
      print(e);
      Get.snackbar("", e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      Navigator.of(context).pop(); // Pop context
    }
  }
}
