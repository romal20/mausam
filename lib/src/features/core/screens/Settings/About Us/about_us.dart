import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text("About Me",style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
        leading: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back)),
      ),
      body: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
    );
  }
}
