import 'package:flutter/material.dart';

class weatherItem extends StatelessWidget {
  const weatherItem({
    super.key,
    required this.value,
    required this.text,
    required this.unit,
    //required this.imageUrl,
    required this.weatherIcon,
  });

  final int value;
  final String text;
  final String unit;
  //final String imageUrl;
  final String weatherIcon;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Column(
      children: [
        Text(text,style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),//Text(text,style: const TextStyle(fontSize: 11.5,fontWeight: FontWeight.bold)),
        const SizedBox(height: 8,),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 60,width: 60,
          decoration: const BoxDecoration(
            color: Color(0xffE0E8FB),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(weatherIcon),
          //child: Image.asset(imageUrl),
        ),
        const SizedBox(height: 8,),
        Text(value.toString() + unit, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)
        // TExt time: 52:23 start
      ],
    );
  }
}