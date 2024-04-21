import 'package:flutter/material.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/text_strings.dart';

// Header widget for the login screen
class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size; // Size of the widget

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
      children: [
        Image.network(welcomeScreenImage, height: size.height * 0.3, width: 500), // Image widget with network image
        Text(
          loginTitle, // Text for the login title
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), // Styling for the login title
        ),
        Text(
          loginSubTitle, // Text for the login subtitle
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300), // Styling for the login subtitle
        ),
      ],
    );
  }
}
