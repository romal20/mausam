import 'package:flutter/material.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    var backgroundcolor = isDarkMode ? Colors.indigoAccent[100] : Colors.lightBlue[50];
    var buttoncolor = isDarkMode ? Colors.indigo[900] : Colors.indigoAccent[200];

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: backgroundcolor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              Image.asset(getStartedImage),
              const SizedBox(height: 30,),
              Container(
                height: 50,
                  width: size.width * 0.7,
                decoration: BoxDecoration(
                  color: buttoncolor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                  child: Text('Get Started',style: TextStyle(color: Colors.white, fontSize:18),
                ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}