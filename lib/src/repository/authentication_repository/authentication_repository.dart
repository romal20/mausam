import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:mausam/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:mausam/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/screens/dashboard/get_started.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
import 'package:mausam/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';

import 'exceptions/exceptions.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  //Variables
  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;
  var verificationId = ''.obs;
  User? get firebaseUser => _firebaseUser.value;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
    //Future.delayed(const Duration(seconds: 6));
   // ever(firebaseUser, _setInitialScreen);
  }

  setInitialScreen(User? user) async{
    user == null ? Get.offAll(() => SplashScreen()) :user.emailVerified ? Get.offAll(() => const HomePage()) :Get.offAll(() => const ForgetPasswordMailScreen());     //Dashboard weather
  }
  Future<void> phoneAuthentication(String phoneNo) async{
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async{
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken){
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId){
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e){
        if(e.code == 'invalid-phone-number'){
          Get.snackbar('Error', 'The provided phone number is not valid.');
        }else{
          Get.snackbar('Error', 'Something went wrong. Try again.');
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async{
    var credentials = await _auth
        .signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  void createUserWithEmailAndPassword(String email, String password) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser != null ? Get.offAll(() => const HomePage()) : Get.to(() => const WelcomeScreen());
    } on FirebaseAuthException catch(e){
      final ex = SignUpEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch(_){
      const ex = SignUpEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  void loginWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential? userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
    } catch(_){
    }
  }

  //Future<void> logout() async => await _auth.signOut();
  Future<void> logout() async{
    //await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future<void> signInWithGoogle() async {
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential.user?.displayName);
    }on FirebaseAuthException catch(e) {
      final ex = Exceptions.fromCode(e.code);
      throw ex.message;
    }catch(_){
      const ex = Exceptions();
      throw ex.message;
    }
  }
}