import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
import 'package:mausam/src/features/core/screens/profile/update_profile.dart';
import 'package:mausam/src/features/core/screens/profile/widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.offAll(() => HomePage());}, icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text("Profile",style: Theme.of(context).textTheme.headlineMedium,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,size: 30,))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,height: 120,
                    child: ClipRRect(borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(profileImage))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        width: 35,height: 35,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: primaryColor,),
                        child: const Icon(LineAwesomeIcons.alternate_pencil,size: 20,color: Colors.black)),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Text(profileHeading,style: Theme.of(context).textTheme.headlineMedium,),
              Text(profileSubHeading,style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () => Get.to(() => UpdateProfileScreen()),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,side: BorderSide.none,shape: const StadiumBorder()),
                    child: const Text("Edit Profile",style: TextStyle(color: darkColor))
                ),
              ),
              const SizedBox(height: 30,),
              const Divider(),
              const SizedBox(height: 10,),
              ProfileMenuWidget(title: Menu1,icon: LineAwesomeIcons.cog,onPress: (){}),
              ProfileMenuWidget(title: Menu2,icon: LineAwesomeIcons.wallet,onPress: (){}),
              ProfileMenuWidget(title: Menu3,icon: LineAwesomeIcons.user_check,onPress: (){}),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10,),
              ProfileMenuWidget(title: Menu4, icon: LineAwesomeIcons.info, onPress: (){}),
              //ProfileMenuWidget(title: Menu5, icon: LineAwesomeIcons.alternate_sign_out, onPress: (){Get.to(()=>WelcomeScreen());},endIcon: false,textColor: Colors.red)
            ],
          ),
        ),
      ),
    );
  }
}

