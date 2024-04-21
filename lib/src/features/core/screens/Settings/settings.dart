import 'package:flutter/material.dart';

// Settings class extends ChangeNotifier to allow for change notification
class Settings extends ChangeNotifier {
  bool isCelsius = true; // Boolean flag to track the temperature unit (Celsius or Fahrenheit)

  // Method to toggle the temperature unit
  void toggleTemperatureUnit() {
    isCelsius = !isCelsius; // Toggle the value of isCelsius
    notifyListeners(); // Notify listeners (Widgets listening to this change) about the change
  }
}
