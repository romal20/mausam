import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mausam/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
//auth = FirebaseAuth.instance;
//firestore = FirebaseFirestore.instance;
//currentUser = Firebase.instance.currentUser;

class AuthController extends GetxController{
  static AuthController get instance => Get.find();

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
    //setInitialScreen(_firebaseUser.value);
    //Future.delayed(const Duration(seconds: 6));
    // ever(firebaseUser, _setInitialScreen);
  }

  //TextControllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  setInitialScreen(User? user){
    user == null ? Get.offAll(() => SplashScreen()) : Get.offAll(() => const HomePage());     //Dashboard whether
  }

  //Login
  Future<UserCredential?> loginMethod({context}) async{
    UserCredential? userCredential;
    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      update();
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
    }on FirebaseAuthException catch(e){
      Get.snackbar(context, e.toString());
    }
    return userCredential;
  }

  //Storing Data
  storeUserData(name,email,password) async{
    DocumentReference store = await FirebaseFirestore.instance.collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    store.set({'Name':name,'Email':email,'Password':password,'imageURL':''});
  }

  //signout
  signOutMethod(context) async{
    try{
      await FirebaseAuth.instance.signOut();
    }catch(e){
      Get.snackbar(context, e.toString());
    }
  }
}