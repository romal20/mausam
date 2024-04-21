import 'package:flutter/material.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetTheMakerPage extends StatelessWidget {
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
        title: Text("Meet the Maker",style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
        leading: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back,color: isDarkMode ? Colors.white : Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      child: ClipOval(
                        child: Image.network(
                          profileImage,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Romal Shah',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    //SizedBox(height: 10),
                    Text(
                      'Developer',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text("Contact Me",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              /*ListTile(
                leading: Icon(Icons.email),
                title: Text('mausamapp03@gmail.com'),
                onTap: () async {
                  String? encodeQueryParameters(
                      Map<String,String> params){
                    return params.entries.map((MapEntry<String,String> e) => '${Uri.encodeComponent(e.key)} = ${Uri.encodeComponent(e.value)}').join('&');
                  }
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'mausamapp03@gmail.com',
                    query: encodeQueryParameters(<String,String>{
                      'subject': 'Contact',
                      'body':''
                    }),
                  );
                  if(await canLaunchUrl(emailUri)){
                    launchUrl(emailUri);
                  }else{
                    throw Exception('Could not launch $emailUri');
                  }
                },
              ),*/
              ListTile(
                leading: Icon(Icons.email),
                title: Text('mausamapp03@gmail.com'),
                onTap: () async {
                  String encodeQueryParameters(Map<String, String> params) {
                    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
                  }

                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'mausamapp03@gmail.com',
                    query: encodeQueryParameters({
                      'subject': '',
                      'body': '',
                    }),
                  );

                  try {
                    await launchUrl(Uri.parse(emailUri.toString()));
                  } catch (e) {
                    print('Error launching email: $e');
                  }
                },
              ),

              SizedBox(height: 40),
              Text(
                'Hello, Mausam Mates!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'I\'m Romal Shah, the creative mind and sole developer behind Mausam App. Discover what makes this app special and learn about its journey from idea to reality.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'My Story',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Ever since I can remember, I\'ve been fascinated by the world of technology and its endless possibilities. I embarked on my journey into app development with a burning passion to create something meaningful and impactful.  It reflects my commitment to delivering solutions that are not just functional, but also intuitive and user-friendly.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'The Journey',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Developing Mausam has been a labor of love. From the initial concept to the final product, every step has been meticulously crafted to provide you with a seamless and enjoyable experience. As a one-person team, I\'ve worn many hats – from designer to developer to tester – to ensure that every feature meets the highest standards.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'What Drives Me',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'What drives me is the desire to create something that makes a difference in people\'s lives. Whether it\'s simplifying a task, providing useful information, or sparking joy, I strive to make your experience with Mausam a memorable one. Your feedback and support have been instrumental in shaping the app into what it is today, and I am grateful for the opportunity to continue improving it.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Thank You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Thank you for joining me on this journey. I hope that Mausam brings you as much joy and utility as it has brought me in creating it. Here\'s to many more updates, improvements, and exciting features ahead!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}