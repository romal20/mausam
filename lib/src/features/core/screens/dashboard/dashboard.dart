import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/authentication/controllers/login_controller.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/screens/profile/profile_screen.dart';
import 'package:mausam/src/repository/authentication_repository/authentication_repository.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Text(appName, style: Theme.of(context).textTheme.headlineMedium,),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
            child: IconButton(
                onPressed: () async {
                  await Get.put(AuthController()).signOutMethod(context);
                  Get.offAll(() => WelcomeScreen());
                },
                icon: const Image(image: AssetImage(profileImage))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
        ),
      ),
    );
  }
}
