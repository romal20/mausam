import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mausam/firebase_options.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';

import 'package:mausam/src/repository/authentication_repository/authentication_repository.dart';
import 'package:mausam/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = WelcomeScreen();
  AuthController authController = AuthController();
  // This widget is the root of your application.
  @override
  void initState(){
    super.initState();
  }

  void checkLogin() async{
    String? token = await authController.getToken();
    if(token!=null){
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  Widget build(BuildContext context) {
    return GetMaterialApp(
    theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      //defaultTransition: Transition.cupertino,
      //transitionDuration: const Duration(milliseconds: 500),
      home: currentPage,
    );
  }
}

/*
class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mausam")),
      body: const Center(child: Text("Personal Weather Oracle"))
    );
  }
}
*/