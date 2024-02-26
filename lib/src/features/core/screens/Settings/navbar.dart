import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/core/screens/Settings/About%20Us/about_us.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mausam/src/features/core/screens/profile/update_profile.dart';
import 'Feedback/feedback.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NavBar extends StatefulWidget {
  final Function(bool) onToggleTemperature;

  const NavBar({Key? key,required this.onToggleTemperature}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int selectedIndex;

  @override
  void initState(){
    super.initState();
    selectedIndex = 0;
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
          Center(child: Text('mausamapp03@gmail.com',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 14,fontWeight: FontWeight.bold))),
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
          ListTile(
            leading: Icon(LineAwesomeIcons.calculator),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Units', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w300)),
                /*Switch(
                  value: isCelsius,  // Use isCelsius to track the selected unit
                  onChanged: (value) {
                    setState(() {
                      isCelsius = false;  // Update the selected unit
                    });
                  },
                  activeColor: _constants.corePrimaryColor,
                  inactiveTrackColor: isDarkMode ? Colors.yellow : Colors.yellow,
                  inactiveThumbColor: isDarkMode ? Colors.red : Colors.red,
                ),*/
                /*ToggleButtons(
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
                ),*/
                ToggleSwitch(
                  labels: [
                    "\u2103",            //Celsisus
                    "\u2109"          //Fahrenheit
                  ],
                  //fontSize: 20,
                  minWidth: 50,
                  minHeight: 30,
                  cornerRadius: 30,
                  initialLabelIndex: selectedIndex,
                  onToggle: (index){
                    setState(() {
                      selectedIndex = index!;
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
          ),
          Divider(color: isDarkMode ? Colors.white : Colors.black),
          ListTile(
            leading: Icon(LineAwesomeIcons.comment),
            title: Text('Feedback',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.w300),),
            onTap: (){Get.to(() => FeedbackPage());},
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Us',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.w300),),
            onTap: (){Get.to(() => AboutMe());},
          ),
  //        Divider(color: isDarkMode ? Colors.white : Colors.black),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text('Log Out',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.w300),),
            onTap: (){authController.signOutMethod(context);},
          )
        ],
      )
    );
  }
}

