import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Constants _constants = Constants();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Romal',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 16,fontWeight: FontWeight.w300),),
            accountEmail: Text('mausamapp03@gmail.com',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 16,fontWeight: FontWeight.w300)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.network(profileImage,width: 90,height: 90,fit: BoxFit.cover,)
              ),
            ),
            decoration: BoxDecoration(
              color: _constants.corePrimaryColor,
                image: DecorationImage(
                  image: NetworkImage(drawerBg),fit: BoxFit.cover,
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Edit Profile'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Manage City'),
            onTap: (){Get.to(() => CityOption());},
          ),
          ListTile(
            leading: Icon(Icons.scale_outlined),
            title: Text('Units'),
            onTap: null,
          ),
          Divider(color: Colors.black,),
          ListTile(
            leading: Icon(Icons.feedback_outlined),
            title: Text('Feedback'),
            onTap: null,
          ),
          Divider(color: Colors.black,),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Us'),
            onTap: null,
          ),
        ],
      )
    );
  }
}
