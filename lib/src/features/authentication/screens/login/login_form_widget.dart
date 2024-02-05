import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/authentication/controllers/login_controller.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';
import 'package:mausam/src/features/core/screens/dashboard/get_started.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //TextEditingController email = TextEditingController();
  //TextEditingController password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSecurePassword = true;

  @override
  Widget build(BuildContext context) {
  //final controller = Get.put(LoginController());
    final authController = Get.put(AuthController());
    return Form(
      key: _formKey,
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          TextFormField(
            controller: authController.emailController,
          validator: MultiValidator([
            RequiredValidator(errorText: "* Required"),
            EmailValidator(errorText: "Enter valid email-id"),
          ]),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: Email,
                hintText: Email,
                border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 30.0),
          TextFormField(
            controller: authController.passwordController,
            obscureText: _isSecurePassword,
            validator: MultiValidator([
              RequiredValidator(errorText: "* Required"),
              MinLengthValidator(6,errorText: "Password should be atleast 6 characters"),
              MaxLengthValidator(15,errorText: "Password should not be greater than 15 characters")
            ]),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: Password,
                hintText: Password,
                border: OutlineInputBorder(),
                suffixIcon: togglePassword()

                /*IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                )*/
            ),
          ),
          const SizedBox(height: 10.0),

          //Forget Password Button
          Align(
              alignment:Alignment.centerRight,
              child: TextButton(onPressed: (){
                Get.to(() => ForgetPasswordMailScreen());
                //ForgetPasswordScreen.buildShowModalBottomSheet(context);
              }, child: Text(forgetPassword, style: TextStyle(color: Colors.blue)))),

          //Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed:() async{
                  if (_formKey.currentState!.validate()) {
                    await authController.loginMethod(context: context).then((value){
                          if(value!=null){
                            Get.snackbar("Success", "Logged In Successfully.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.withOpacity(0.1),
                                colorText: Colors.green);
                            //Get.offAll(() => const Dashboard());
                            Get.off(const CityOption());
                          }
                    }
                    );

                    /*try {
                      //Email-Password Authentication
                      LoginController.instance.loginUser(
                          controller.email.text.trim(),
                          controller.password.text.trim());
                      Get.to(() => CityOption());
                    }catch(e){
                      print('Navigation error: $e');
                    }*/

                  }
                },
              child: Text("LOGIN"),
            ),
          )
        ],
      ),
    ));
  }

  Widget togglePassword() {
    return IconButton(onPressed: () {
      setState(() {
        _isSecurePassword = !_isSecurePassword;
      });

    }, icon: _isSecurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),color: Colors.grey,);
  }

}

