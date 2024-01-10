import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/screens/dashboard/home.dart';
import '../screens/splash_screen/splash_screen.dart';
//auth = FirebaseAuth.instance;
//firestore = FirebaseFirestore.instance;
//currentUser = Firebase.instance.currentUser;


class AuthController extends GetxController{

  //TextControllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  setInitialScreen(User? user){
    user == null ? Get.offAll(() => SplashScreen()) : Get.offAll(() => const Home());     //Dashboard weather
  }

  //Login
  Future<UserCredential?> loginMethod({context}) async{
    UserCredential? userCredential;
    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
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