import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityStorage {
  static const _key = 'selectedCities';

  static Future<List<String>> getSelectedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cities = prefs.getStringList(_key);
    return cities ?? [];
  }

  static Future<void> saveSelectedCities(List<String> cities) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, cities);
  }
}
