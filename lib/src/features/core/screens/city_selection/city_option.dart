import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/core/screens/city_selection/city.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';

class CityOption extends StatefulWidget {
  const CityOption({Key? key}) : super(key: key);

  @override
  State<CityOption> createState() => _CityOptionState();
}

class _CityOptionState extends State<CityOption> {
  late List<City> cities; // List to hold the cities
  late List<City> selectedCities; // List to hold the selected cities
  var latitude; // Latitude of the user's current location
  var longitude; // Longitude of the user's current location

  @override
  void initState() {
    super.initState();
    _loadCities(); // Load the list of cities
  }

  Future<void> _loadCities() async { // Asynchronous method to load the cities
    setState(() { // Set the state
      cities = City.citiesList.where((city) => city.isDefault == false).toList(); // Filter cities that are not default
    });
  }

  Future<void> getLocation() async { // Asynchronous method to get the user's location
    LocationPermission permission = await Geolocator.checkPermission(); // Check location permission

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) { // If permission is denied
      print("Permission not given"); // Print a message
      Geolocator.requestPermission(); // Request permission
    } else { // If permission is granted
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true); // Get current position
      print(position); // Print the position
    }
  }

  @override
  Widget build(BuildContext context) { // Build method for building the widget
    Size size = MediaQuery.of(context).size; // Get the screen size
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark; // Check if dark mode is enabled
    Constants _constants = Constants(); // Create an instance of Constants class

    return Scaffold( // Scaffold widget for the screen
      appBar: AppBar( // AppBar for the screen
        automaticallyImplyLeading: false, // Don't show the back button
        backgroundColor: isDarkMode ? Colors.black87 : coreColor2, // Set the app bar color based on dark mode
        title: Text(selectedCities.length.toString() + ' selected'), // Set the app bar title
      ),
      body: Container( // Container for the body content
        color: isDarkMode ? Colors.black : Colors.white, // Set the background color
        child: ListView.builder( // ListView for displaying the cities
          physics: const BouncingScrollPhysics(), // Set the physics of the list view
          itemCount: cities.length, // Set the number of items in the list view
          itemBuilder: (BuildContext context, int index) { // Item builder for the list view
            return Container( // Container for each city item
              margin: const EdgeInsets.only(left: 10, top: 20, right: 10), // Set margin
              padding: const EdgeInsets.symmetric(horizontal: 10), // Set padding
              height: size.height * .08, // Set height
              width: size.width, // Set width
              decoration: BoxDecoration( // Decoration for the container
                  color: isDarkMode ? Colors.black : coreColor1.withOpacity(0.2), // Set background color
                  border: cities[index].isSelected == true ? Border.all( // Set border based on city selection
                    color: isDarkMode ? coreColor2 : coreColor2.withOpacity(.6), // Set border color
                    width: 2, // Set border width
                  ) : Border.all(color: Colors.white), // Set border color if not selected
                  borderRadius: const BorderRadius.all(Radius.circular(10)), // Set border radius
                  boxShadow: [ // Add a box shadow
                    BoxShadow( // Define the box shadow
                      color: isDarkMode ? Colors.white.withOpacity(.2) : coreColor1.withOpacity(.2), // Set shadow color
                      spreadRadius: 4, // Set shadow spread radius
                      blurRadius: 6, // Set shadow blur radius
                      offset: const Offset(0, 3), // Set shadow offset
                    )
                  ]
              ),
              child: Row( // Row for displaying city information
                children: [
                  GestureDetector( // GestureDetector for handling taps
                    onTap: () { // onTap event for handling taps
                      setState(() { // Set the state
                        cities[index].isSelected =! cities[index].isSelected; // Toggle city selection
                      });
                    },
                    child: Image.network(cities[index].isSelected == true ? checked : unchecked, width: 30,), // Display check or uncheck image based on selection
                  ),
                  const SizedBox(width: 10,), // Add some spacing
                  Text(cities[index].city, style: TextStyle( // Display the city name
                      fontSize: 16, // Set font size
                      color: isDarkMode ? Colors.white : Colors.black // Set text color based on dark mode
                  ))
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton( // FloatingActionButton for getting the user's location
        backgroundColor: isDarkMode? Colors.white : coreColor2, // Set background color
        child: Icon(Icons.pin_drop, color: isDarkMode ? Colors.black : Colors.white), // Set icon
        onPressed: (){ // onPressed event for handling button tap
          getLocation(); // Get the user's location
          Get.offAll(() => const HomePage()); // Navigate to the home page
        },
      ),
    );
  }
}
