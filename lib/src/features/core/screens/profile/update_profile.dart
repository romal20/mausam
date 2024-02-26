import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mausam/src/features/core/controllers/profile_controller.dart';
import '../../../authentication/models/user_model.dart';
import 'firestore_service.dart'; // Import your FirestoreService

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  ProfileController controller = ProfileController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: controller.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final userData = snapshot.data!;
            final email = userData.data()?['Email'];
            final password = userData.data()?['Password'];
            final name = userData.data()?['Name'];
            return Column();
            // Do something with email, password, and name...
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

  }
}
