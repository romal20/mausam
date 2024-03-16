import 'package:flutter/material.dart';
import 'package:mausam/src/constants/image_strings.dart';

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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 30,),
          CircleAvatar(
            radius: 80,
            child: ClipOval(
                child: Image.network(profileImage,width: 150,height: 150,fit: BoxFit.cover,)
            ),
//            radius: 100,
            //backgroundImage: NetworkImage(profileImage),
          ),
          SizedBox(height: 20),
          Text(
            'Romal Shah',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Developer',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          Text(
            'Welcome to Mausam!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Mausam provides accurate weather forecasts to help you plan your day, whether it\'s sunny or rainy. \nWith Mausam, you can stay ahead of the weather, ensuring you\'re always prepared for the day ahead.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 50),
          Text("Contact Me",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('mausamapp03@gmail.com'),
            onTap: () {
              // Handle email tap
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.phone),
          //   title: Text('+1 234 567 890'),
          //   onTap: () {
          //     // Handle phone tap
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.location_on),
          //   title: Text('123 Main Street, Anytown, USA'),
          //   onTap: () {
          //     // Handle address tap
          //   },
          // ),
        ],
      ),
    );
  }
}

