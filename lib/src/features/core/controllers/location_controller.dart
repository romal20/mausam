import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController{
  // A reactive boolean to track if location access is in progress
  final RxBool isAccessingLocation = RxBool(false);

  // A reactive string to hold any error description related to location
  final RxString errorDescription = RxString("");

  // A reactive location data to hold the user's current location
  final Rx<LocationData?> userLocation = Rx<LocationData?>(null);

  // Method to update the status of location access
  void updateIsAccessingLocation(bool b){
    isAccessingLocation.value = b;
  }

  // Method to update the user's location
  void updateUserLocation(LocationData data){
    userLocation.value = data;
  }
}
