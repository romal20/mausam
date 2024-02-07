import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mausam/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//auth = FirebaseAuth.instance;
//firestore = FirebaseFirestore.instance;
//currentUser = Firebase.instance.currentUser;

class AuthController extends GetxController{
  static AuthController get instance => Get.find();
  final storage = const FlutterSecureStorage();
  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  var verificationId = ''.obs;
  User? get firebaseUser => _firebaseUser.value;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    _setInitialScreen(_firebaseUser.value);
    //Future.delayed(const Duration(seconds: 6));
     //ever(_firebaseUser, _setInitialScreen);
  }

  //TextControllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _setInitialScreen(User? user){
    user == null ? Get.offAll(() => SplashScreen()) : Get.offAll(() => const HomePage());     //Dashboard whether
  }

  //Login
  Future<UserCredential?> loginMethod({context}) async{
    UserCredential? userCredential;
    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      update();
      storeTokenAndData(userCredential);
    }on FirebaseAuthException catch(e){
      Get.snackbar(context, e.toString());
    }
    return userCredential;
  }

  //Signup
  Future<UserCredential?> signUpMethod({email,password,context}) async{
    UserCredential? userCredential;
    try{
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      update();
      //firebaseUser != null ? Get.offAll(() => const HomePage()) : Get.to(() => const WelcomeScreen());
    }on FirebaseAuthException catch(e){
      Get.snackbar(context, e.toString());
    }
    return userCredential;
  }

  //Storing Data
  storeUserData(name,email,password) async{
    DocumentReference store = FirebaseFirestore.instance.collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    store.set({'Name':name,'Email':email,'Password':password,'imageURL':''});
  }

  //signout
  signOutMethod(context) async{
    try{
      await FirebaseAuth.instance.signOut();
      await storage.delete(key: "token");
      Get.offAll(() => WelcomeScreen());
    }catch(e){
      Get.snackbar(context, e.toString());
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async{
    await storage.write(key: "token", value: userCredential.credential?.token.toString());
    await storage.write(key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async{
    return await storage.read(key: "token");
  }
}