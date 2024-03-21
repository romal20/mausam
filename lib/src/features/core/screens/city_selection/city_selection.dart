import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CitySelection {
  static Future<List<String>> getSelectedCities() async {
    List<String> selectedCities = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
      await FirebaseFirestore.instance.collection('selectedCities').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> cities = snapshot.data()!['cities'] ?? [];
        selectedCities = cities.cast<String>();
      }
    }
    return selectedCities;
  }

  static Future<void> saveSelectedCities(List<String> cities) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('selectedCities').doc(user.uid).set({
        'cities': cities,
      });
    }
  }
}
