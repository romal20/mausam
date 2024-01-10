import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    Key? key,
    this.imageColor,
    this.heightBetween,
    required this.image,
    required this.title,
    required this.subTitle,
    this.imageHeight = 0.3,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  //Variables declared in constructor
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final String image,title,subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(image: AssetImage(image),color: imageColor, height: size.height*imageHeight,width: 400,),
        //SizedBox(height: 10,),
        Text(title,style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
        Text(subTitle,textAlign: textAlign,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300)),
        //SizedBox(height: 10,),
      ],
    );
  }
}