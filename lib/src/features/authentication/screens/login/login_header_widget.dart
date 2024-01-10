import 'package:flutter/material.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(welcomeScreenImage),height: size.height*0.3,width: 500,),
        Text(loginTitle,style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
        Text(loginSubTitle,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300)),
      ],
    );
  }
}