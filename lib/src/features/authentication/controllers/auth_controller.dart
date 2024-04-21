import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mausam/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

// Controller for handling authentication logic
class AuthController extends GetxController {
  // Get instance of the AuthController
  static AuthController get instance => Get.find();

  // Initialize secure storage for sensitive data
  final storage = const FlutterSecureStorage();

  // Firebase authentication instance
  final _auth = FirebaseAuth.instance;

  // Reactive variable for current Firebase user
  late final Rx<User?> _firebaseUser;

  // Getter for the current Firebase user
  User? get firebaseUser => _firebaseUser.value;

  @override
  void onReady() {
    // Bind the userChanges stream to the firebaseUser reactive variable
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    _setInitialScreen(_firebaseUser.value);
  }

  // Controllers for email and password input fields
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Set the initial screen based on the user's authentication status
  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => SplashScreen()) : Get.offAll(() => const HomePage());
  }

  // Method for logging in a user
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      update();
      storeTokenAndData(userCredential);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(context, e.toString());
    }
    return userCredential;
  }

  // Method for signing up a user
  Future<UserCredential?> signUpMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      update();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(context, e.toString());
    }
    return userCredential;
  }

  // Method for storing user data securely
  storeUserData(name, email, password) async {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));
    final encryptedPassword = encrypter.encrypt(password, iv: encrypt.IV.fromLength(16));
    DocumentReference store = FirebaseFirestore.instance.collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    store.set({'ID': FirebaseAuth.instance.currentUser!.uid, 'Name': name, 'Email': email, 'Password': encryptedPassword.base64});
  }

  // Method for signing out a user
  signOutMethod(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await storage.delete(key: "token");
      Get.offAll(() => WelcomeScreen());
    } catch (e) {
      Get.snackbar(context, e.toString());
    }
  }

  // Method for storing the user token and data
  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(key: "token", value: userCredential.credential?.token.toString());
    await storage.write(key: "userCredential", value: userCredential.toString());
  }

  // Method for retrieving the stored user token
  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
}
