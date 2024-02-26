import 'package:flutter/material.dart';

class Settings extends ChangeNotifier{
  bool isCelsius = true;

  void toggleTemperatureUnit(){
    isCelsius = !isCelsius;
    notifyListeners();
  }
}