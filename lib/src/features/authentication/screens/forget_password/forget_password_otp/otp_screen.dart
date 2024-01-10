import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/controllers/otp_controller.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var otpController = Get.put(OTPController());
    var otp;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(otpTitle,style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 80.0)),
            Text(otpSubTitle.toUpperCase(),style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 30.0),
            Text(otpMessage , textAlign: TextAlign.center,),
            const SizedBox(height: 20.0,),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code){
                otp = code;
                OTPController.instance.verifyOTP(otp);
                },
            ),
            const SizedBox(height: 20.0,),
            SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: (){
                  OTPController.instance.verifyOTP(otp);
                },
                child: const Text("Next")))
          ],
        ),
      ),
    );
  }
}
