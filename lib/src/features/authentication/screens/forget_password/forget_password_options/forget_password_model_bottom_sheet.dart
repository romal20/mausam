import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';

class ForgotPasswordScreen{
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(context: context, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),builder: (context) => Container(
      padding: const EdgeInsets.all(defaultSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(forgotPasswordTitle,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),//style: Theme.of(context).textTheme.displayMedium,),
          Text(forgotPasswordSubTitle,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300)) ,//style: Theme.of(context).textTheme.bodyMedium,),
          const SizedBox(height: 30.0),
          ForgotPasswordBtnWidget(
            onTap: (){
              Navigator.pop(context);
              Get.to(()=>const ForgotPasswordMailScreen());},
            title: Email,
            btnIcon: Icons.mail_outline_rounded,
            subTitle: resetViaEmail,
          ),
          const SizedBox(height: 20.0,),
          ForgotPasswordBtnWidget(
            onTap: (){
              Navigator.pop(context);
              Get.to(()=>const OTPScreen());
            },
            title: PhoneNo,
            subTitle: resetViaPhone,
            btnIcon: Icons.mobile_friendly_rounded,
          ),
        ],
      ),
    )
    );
  }
}