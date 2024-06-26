import 'package:flutter/material.dart';

class Constants{
  final corePrimaryColor = const Color(0xff6b9dfc);
  final coreSecondaryColor = const Color(0xffa1c6fd);
  final coreTertiaryColor = const Color(0xffbec5ff);
  final blackColor = const Color(0xff1a1d26);
  final greyColor = const Color(0xffd9dadb);

  final Shader shader = const LinearGradient(colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final linearGradientBlue = const LinearGradient(
    begin:  Alignment.bottomRight,
    end:  Alignment.topLeft,
    colors: [Color(0xff6b9dfc), Color(0xff205cf1)],
    stops: [0.0,1.0]
  );

  final linearGradientPurple = const LinearGradient(
      begin:  Alignment.bottomRight,
      end:  Alignment.topLeft,
      colors: [Color(0xff51087E), Color(0xff205cf6C0BA9)],
      stops: [0.0,1.0]
  );

}