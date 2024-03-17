import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/core/screens/Settings/About%20Me/meet_the_maker.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mausam/src/features/core/screens/profile/update_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Feedback/feedback.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NavBar extends StatefulWidget {
  final Function(bool) onToggleTemperature;
  final Function(bool) onToggleWind;

  const NavBar({Key? key,required this.onToggleTemperature, required this.onToggleWind}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selectedTemp = 0;
  int selectedWind = 0;
  bool isCelsius = true;
  bool isKph = true;
  final authController = Get.put(AuthController());
  final firestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    /*    selectedTemp = 0;
    selectedWind = 0;
    */
    loadUserPreferences();
  }

  void loadUserPreferences() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('UserPreference').doc(FirebaseAuth.instance.currentUser!.uid).get();
    print(FirebaseAuth.instance.currentUser!.uid);

    if (snapshot.exists) {
      setState(() {
        selectedTemp = snapshot.data()?['selectedTemp'] == true ? 0 : 1;
        selectedWind = snapshot.data()?['selectedWind'] == true ? 0 : 1;
      });
    }
  }

  void saveUserPreferences() async {
      isCelsius = selectedTemp == 0; // Convert selectedTemp to boolean
      isKph = selectedWind == 0; // Convert selectedWind to boolean

      await firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('UserPreference').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'selectedTemp': isCelsius,
        'selectedWind': isKph,
        //'id': FirebaseAuth.instance.currentUser!.uid,
      });

  /*  await firestore.collection('UserPreference').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'selectedTemp': selectedTemp,
      'selectedWind': selectedWind,
      'id':FirebaseAuth.instance.currentUser!.uid
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final authController = Get.put(AuthController());
    Constants _constants = Constants();
    bool isCelsius = true;

    return Drawer(
      backgroundColor: isDarkMode ? Color(0xff02073d)  : Color(0xffcfe3ff),
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          SizedBox(height: 30,),
          Container(
            alignment: Alignment.center,
            child: ClipRect(
              child: Image.asset(
                "assets/images/weather-app.png",
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Center(child: Text('Mausam',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 24,fontWeight: FontWeight.bold),)),
          ListTile(
            title: Text('mausamapp03@gmail.com',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
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
          //Center(child: Text('mausamapp03@gmail.com',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 14,fontWeight: FontWeight.bold))),
          Divider(color: isDarkMode ? Colors.white : Colors.black),
          SizedBox(height: 40,),
          /*UserAccountsDrawerHeader(
            accountName: Text('Mausam',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
            accountEmail: Text('mausamapp03@gmail.com',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 14,fontWeight: FontWeight.w500)),
            *//*currentAccountPicture: *//**//*CircleAvatar(
              backgroundColor: isDarkMode ? Color(0xff020f42)  : Color(0xffcfe3ff),
              child: *//*
            *//*Center(
              child: ClipOval(
                    child: Image.asset("assets/images/weather-app.png",width: 90,height: 90,fit: BoxFit.cover,)
                ),
            ),
*//*            // ),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xff020f42)  : Color(0xffccdef5),
                // image: DecorationImage(
                //   image: NetworkImage(drawerBg),fit: BoxFit.cover,
                //)
            ),
          ),*/
          // ListTile(
          //   leading: Icon(LineAwesomeIcons.user_edit),
          //   title: Text('Edit Profile',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.w300),),
          //   onTap: (){Get.to(() => UpdateProfileScreen());},
          // ),
          // ListTile(
          //   leading: Icon(Icons.location_city_outlined),
          //   title: Text('Manage City',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.w300),),
          //   onTap: (){Get.to(() => CityOption());},
          // ),
          /*ListTile(
            leading: Icon(LineAwesomeIcons.calculator),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Units', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w300)),
                *//*Switch(
                  value: isCelsius,  // Use isCelsius to track the selected unit
                  onChanged: (value) {
                    setState(() {
                      isCelsius = false;  // Update the selected unit
                    });
                  },
                  activeColor: _constants.corePrimaryColor,
                  inactiveTrackColor: isDarkMode ? Colors.yellow : Colors.yellow,
                  inactiveThumbColor: isDarkMode ? Colors.red : Colors.red,
                ),*//*
                *//*ToggleButtons(
                  children: [
                    Text('°C'),
                    Text('°F'),
                  ],
                  isSelected: [isCelsius, !isCelsius],
                  onPressed: (index) {
                    setState(() {
                      isCelsius = index == 0;
                      print(isCelsius);
                    });
                  },
                ),*//*
                ToggleSwitch(
                  labels: [
                    "\u2103",            //Celsisus
                    "\u2109"          //Fahrenheit
                  ],
                  //fontSize: 20,
                  minWidth: 50,
                  minHeight: 30,
                  cornerRadius: 30,
                  initialLabelIndex: selectedTemp,
                  onToggle: (index){
                    setState(() {
                      selectedTemp = index!;
                      widget.onToggleTemperature(index == 0);
                      print("index: "+index.toString());
                    });
                    //isCelsius = index == 0 ? true : false;
                    //onToggleTemperature(isCelsius);
                  },
                  activeBgColor: [
                    Colors.lightBlue,
                    Colors.indigo
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                ),
                ToggleSwitch(
                  labels: [
                    "kph",            //Celsisus
                    "mph"          //Fahrenheit
                  ],
                  //fontSize: 20,
                  minWidth: 50,
                  minHeight: 30,
                  cornerRadius: 30,
                  initialLabelIndex: selectedWind,
                  onToggle: (index){
                    setState(() {
                      selectedWind = index!;
                      widget.onToggleTemperature(index == 0);
                      print("index: "+index.toString());
                    });
                    //isCelsius = index == 0 ? true : false;
                    //onToggleTemperature(isCelsius);
                  },
                  activeBgColor: [
                    Colors.lightBlue,
                    Colors.indigo
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                )
              ],
            ),
            onTap: null,
          ),*/
          ListTile(
            leading: Icon(LineAwesomeIcons.calculator,size: 28,),
            title: Text('Units', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold,fontSize: 20)),
            onTap: null,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Temperature', style: TextStyle(color: isDarkMode ? Colors.white : Color(
                      0xff2b72fa), fontWeight: FontWeight.bold,fontSize: 16)),
                  ToggleSwitch(
                    labels: [
                      "\u2103",            //Celsisus
                      "\u2109"          //Fahrenheit
                    ],
                    customTextStyles: [
                      TextStyle(fontWeight: FontWeight.bold,fontSize: 16)
                    ],
                    //fontSize: 20,
                    minWidth: 60,
                    minHeight: 30,
                    cornerRadius: 30,
                    initialLabelIndex: selectedTemp,
                    onToggle: (index){
                      setState(() {
                        selectedTemp = index!;
                        widget.onToggleTemperature(index == 0);
                        saveUserPreferences();
                        print("index: "+index.toString());
                      });
                      //isCelsius = index == 0 ? true : false;
                      //onToggleTemperature(isCelsius);
                    },
                    activeBgColor: [
                      _constants.corePrimaryColor
                    ],
                    activeFgColor: Colors.white,
                    inactiveFgColor: isDarkMode ? Colors.black : Colors.black,
                    inactiveBgColor: _constants.coreSecondaryColor,
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Wind Speed', style: TextStyle(color: isDarkMode ? Colors.white : Color(0xff2b72fa), fontWeight: FontWeight.bold,fontSize: 16)),
                  ToggleSwitch(
                    labels: [
                      "km/h",            //Celsisus
                      "m/h"          //Fahrenheit
                    ],
                    customTextStyles: [
                      TextStyle(fontWeight: FontWeight.bold,fontSize: 13)
                    ],
                    minWidth: 60,
                    minHeight: 35,
                    cornerRadius: 30,
                    initialLabelIndex: selectedWind,
                    onToggle: (index){
                      setState(() {
                        selectedWind = index!;
                        widget.onToggleWind(index == 0);
                        saveUserPreferences();
                        print("index: "+index.toString());
                      });
                      //isCelsius = index == 0 ? true : false;
                      //onToggleTemperature(isCelsius);
                    },
                    activeBgColor: [
                      _constants.corePrimaryColor
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: _constants.coreSecondaryColor,
                    inactiveFgColor: isDarkMode ? Colors.black : Colors.black,
                  )
                ],
              ),
            ],
          ),
          Divider(color: isDarkMode ? Colors.white : Colors.black),
          ListTile(
            leading: Icon(LineAwesomeIcons.comment),
            title: Text('Feedback',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.bold),),
            onTap: (){Get.to(() => FeedbackPage());},
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Meet the Maker',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.bold),),
            onTap: (){Get.to(() => MeetTheMakerPage());},
          ),
  //        Divider(color: isDarkMode ? Colors.white : Colors.black),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text('Log Out',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.bold),),
            onTap: (){authController.signOutMethod(context);},
          )
        ],
      )
    );
  }

}

