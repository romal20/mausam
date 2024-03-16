import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/authentication/controllers/signup_controller.dart';
import 'package:mausam/src/features/authentication/models/user_model.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
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
  String Country = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var authController = Get.put(AuthController());
  bool _isSecurePassword = true;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                  controller: controller.fullName,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(
                        3, errorText: 'Name should be at least 3 characters'),
                    MaxLengthValidator(
                        30, errorText: 'Name should not exceed 30 characters'),
                    PatternValidator(r'^[a-zA-Z\s]+$',
                        errorText: 'Please enter a valid name'),
                  ]),
                  decoration: const InputDecoration(
                    label: Text("Full Name"),
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  )
              ),
              const SizedBox(height: 20.0),
              /*TextFormField(
                  controller: controller.phoneNo,

                  decoration: const InputDecoration(
                    label: Text("Phone Number with country code"),
                    hintText: "+919876543210",
                    prefixIcon: Icon(Icons.phone_outlined),
                  )
              ),
              IntlPhoneField(
                controller: controller.phoneNo,
                disableLengthCheck: true,
                keyboardType: TextInputType.phone,
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  //print(phone.completeNumber);
                  debugPrint('Below is phone number');
                  debugPrint(phone.completeNumber);
                  debugPrint('Country code is: ${phone.countryCode}');
                  Country = phone.countryCode;
                  debugPrint(Country);
                  },
                decoration: InputDecoration(
                    labelText: '  Phone Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide()
                    )
                ),
              ),
              const SizedBox(height: 10.0),*/
              TextFormField(
                  controller: controller.email,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    EmailValidator(errorText: "Enter valid Email Id"),
                  ]),
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    prefixIcon: Icon(Icons.email_outlined),
                  )
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                  controller: controller.password,
                  obscureText: _isSecurePassword,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(6, errorText: "Password should be atleast 6 characters"),
                    MaxLengthValidator(15, errorText: "Password should not be greater than 15 characters")
                  ]),
                  decoration: InputDecoration(
                    label: Text("Password"),
                    prefixIcon: Icon(Icons.fingerprint),
                    suffixIcon: togglePassword()
                  )
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try{
//                          verifyEmail;
                          await authController.signUpMethod(
                            email: controller.email.text.trim(),
                            password: controller.password.text.trim(),
                            context: context).then((value){
                          return authController.storeUserData(
                            controller.fullName.text,controller.email.text,controller.password.text);
                          }).then((value){
                            Get.snackbar("Success", "Signed In Successfully.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.withOpacity(0.1),
                                colorText: Colors.green);
                            Get.offAll(() => HomePage());
                          });
                        }catch(e){
                          FirebaseAuth.instance.signOut();
                          Get.snackbar("Error", e.toString());
                        }
                        /*try {
                          //Email-Password Authentication
                          SignUpController.instance.registerUser(
                              controller.email.text.trim(),
                              controller.password.text.trim());
                          Get.to(() => CityOption());
                        }catch(e){
                          print('Navigation error: $e');
                        }*/
                        //Phone Authentication
                        //SignUpController.instance.phoneAuthentication(controller.phoneNo.text.trim());
                        /*final user = UserModel(
                          email: controller.email.text.trim(),
                          password: controller.password.text.trim(),
                          fullName: controller.fullName.text.trim(),
                          //phoneNo: controller.phoneNo.text.trim()
                        );
                        SignUpController.instance.createUser(user);
                        //Get.to(() => const OTPScreen());*/
                      }
                    },
                    child: Text("SIGN UP")),
              )
            ],
          )
      ),
    );
  }
  Widget togglePassword() {
    return IconButton(onPressed: () {
      setState(() {
        _isSecurePassword = !_isSecurePassword;
      });

    }, icon: _isSecurePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),color: Colors.grey,);
  }


  Future verifyEmail() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification().whenComplete(() =>
      Get.snackbar("Verification Email Sent",
          "Please check your email to verify your email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch(e){
      print(e);
      Get.snackbar("" , e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      Navigator.of(context).pop();
    }
  }
}
