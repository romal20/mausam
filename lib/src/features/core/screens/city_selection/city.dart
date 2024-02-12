import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class City{
  bool isSelected;
  final String city;
  final String country;
  final bool isDefault;

  City({required this.isSelected, required this.city, required this.country, required this.isDefault});
  //List of Cities
  static List<City> citiesList = [
    City(
        isSelected: false,
        city: 'Mumbai',
        country: 'India',
        isDefault: true),
    City(
        isSelected: false,
        city: 'London',
        country: 'United Kindgom',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Tokyo',
        country: 'Japan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Delhi',
        country: 'India',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Beijing',
        country: 'China',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Paris',
        country: 'France',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Rome',
        country: 'Italy',
        isDefault: false),
    City(
        isSelected: false,
        city: 'New York',
        country: 'United States',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Dubai',
        country: 'United Arab Emirates',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Moscow',
        country: 'Russia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Hong Kong',
        country: 'China',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Berlin',
        country: 'Germany',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bangkok',
        country: 'Thailand',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Kathmandu',
        country: 'Nepal',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Nairobi',
        country: 'Kenya',
        isDefault: false),
  ];
  //Get the selected cities
  /*static List<City> getSelectedCities(){
    List<City> selectedCities = City.citiesList;
    return selectedCities
        .where((city) => city.isSelected == true)
        .toList();
  }*/

  static List<City> getSelectedCities(){
    List<City> selectedCities = City.citiesList;
    return selectedCities
        .where((city) => city.isSelected == true)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'isSelected': isSelected,
      'isDefault': isDefault,
    };
  }

  storeSelectedCities(List<City> selectedCities) async {
    try {
      // Convert selected cities to JSON format
      List<Map<String, dynamic>> selectedCitiesJson =
      selectedCities.map((city) => city.toJson()).toList();

      final user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;

      // Store selected cities in Firestore
      await FirebaseFirestore.instance.collection("Users").doc(userId).collection("selected_cities").doc("cities")
          .set({
        'cities': selectedCitiesJson,
      });

      // Show success message
      print("Selected cities are stored successfully.");
    } catch (error) {
      // Show error message
      print("Error: $error");
    }
  }
}

/*
void storeSelectedCities(List<City> selectedCities) async {
  try {
    // Convert selected cities to JSON format
    List<Map<String, dynamic>> selectedCitiesJson =
    selectedCities.map((city) => city.toJson()).toList();

    // Store selected cities in Firestore
    await FirebaseFirestore.instance.collection("selected_cities").add({
      'cities': selectedCitiesJson,
    });

    // Show success message
    print("Selected cities are stored successfully.");
  } catch (error) {
    // Show error message
    print("Error: $error");
  }
}*/
