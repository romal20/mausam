import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> { // State class for login form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isSecurePassword = true; // Flag to toggle password visibility

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController()); // Get instance of AuthController for authentication
    return Form(
      key: _formKey, // Set the form key for validation
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0), // Padding for the form
        child: Column(
          children: [
            TextFormField(
              controller: authController.emailController, // Email text field controller
              validator: MultiValidator([ // Validator for email field
                RequiredValidator(errorText: "* Required"), // Email is required
                EmailValidator(errorText: "Enter valid email-id"), // Email should be valid
              ]),
              autofillHints: [AutofillHints.email], // Autofill hint for email
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined), // Icon for email field
                labelText: Email, // Label text for email field
                hintText: Email, // Hint text for email field
                border: OutlineInputBorder(), // Border for email field
              ),
            ),
            const SizedBox(height: 30.0), // Empty space between email and password fields
            TextFormField(
              controller: authController.passwordController, // Password text field controller
              obscureText: _isSecurePassword, // Whether password is obscured or not
              validator: MultiValidator([ // Validator for password field
                RequiredValidator(errorText: "* Required"), // Password is required
                MinLengthValidator(6, errorText: "Password should be at least 6 characters"), // Password should have minimum length of 6
                MaxLengthValidator(15, errorText: "Password should not be greater than 15 characters"), // Password should not exceed 15 characters
              ]),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint), // Icon for password field
                labelText: Password, // Label text for password field
                hintText: Password, // Hint text for password field
                border: OutlineInputBorder(), // Border for password field
                suffixIcon: togglePassword(), // Icon to toggle password visibility
              ),
            ),
            const SizedBox(height: 10.0), // Empty space between password field and buttons

            // Forget Password Button
            Align(
              alignment: Alignment.centerRight, // Align button to the right
              child: TextButton(
                onPressed: () {
                  Get.to(() => ForgotPasswordMailScreen()); // Navigate to forgot password screen
                },
                child: Text(
                  forgotPassword, // Text for forget password button
                  style: TextStyle(color: Colors.blue), // Styling for text
                ),
              ),
            ),

            // Login Button
            SizedBox(
              width: double.infinity, // Button takes full width
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) { // Validate form fields
                    try {
                      await authController.loginMethod(context: context).then((value) { // Call login method in AuthController
                        if (value != null) {
                          Get.snackbar("Success", "Logged In Successfully.", // Show success snackbar
                            snackPosition: SnackPosition.BOTTOM, // Snackbar position
                            backgroundColor: Colors.green.withOpacity(0.1), // Snackbar background color
                            colorText: Colors.green, // Text color
                          );
                          Get.offAll(() => const HomePage()); // Navigate to home page
                        }
                      });
                    } catch (e) {
                      FirebaseAuth.instance.signOut(); // Sign out if login fails
                      Get.snackbar("Error", e.toString()); // Show error snackbar
                    }
                  }
                },
                child: Text("LOGIN"), // Button text
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton( // IconButton to toggle password visibility
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword; // Toggle password visibility
        });
      },
      icon: _isSecurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off), // Icon based on password visibility
      color: Colors.grey, // Icon color
    );
  }
}