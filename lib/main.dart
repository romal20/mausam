import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mausam/firebase_options.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
//import 'package:mausam/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/controllers/location_controller.dart';
import 'package:mausam/src/features/core/screens/Settings/settings.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
import 'package:provider/provider.dart';
//import 'package:mausam/src/repository/authentication_repository/authentication_repository.dart';
import 'package:mausam/src/utils/theme/theme.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure Flutter is initialized

  // Initialize Firebase and get the authentication controller
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthController()));

  // Run the app with the ChangeNotifierProvider wrapping MyApp
  runApp(ChangeNotifierProvider(
      create: (context) => Settings(),
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = WelcomeScreen();  // Set the initial page to WelcomeScreen
  AuthController authController = AuthController();  // Initialize the authentication controller

  @override
  void initState(){
    super.initState();
  }

  // Check if the user is logged in and update the current page
  void checkLogin() async{
    String? token = await authController.getToken();
    if(token!=null){
      setState(() {
        currentPage = HomePage();  // If logged in, set the current page to HomePage
      });
    }
  }

  // Build method for MyApp
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,  // Set preferred orientation to portrait up
      //DeviceOrientation.landscapeLeft,  // Uncomment if landscape left is allowed
      //DeviceOrientation.landscapeRight,  // Uncomment if landscape right is allowed
      //DeviceOrientation.portraitDown,  // Uncomment if portrait down is allowed
    ]);
    return GetMaterialApp(  // Return a GetMaterialApp widget
      theme: TAppTheme.lightTheme,  // Set the light theme
      darkTheme: TAppTheme.darkTheme,  // Set the dark theme
      themeMode: ThemeMode.system,  // Set the theme mode to follow system theme
      debugShowCheckedModeBanner: false,  // Disable the debug banner
      //defaultTransition: Transition.cupertino,  // Set default transition to Cupertino style
      //transitionDuration: const Duration(milliseconds: 500),  // Set transition duration to 500 milliseconds
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: currentPage,  // Set the initial home page
      )
    );
  }
}


//To connect adb:
// C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\