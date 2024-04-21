import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mausam/src/common_widgets/weather_item/weather_item.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:mausam/src/features/core/controllers/location_controller.dart';
import 'package:mausam/src/features/core/screens/Settings/Location/location_services.dart';
import 'package:mausam/src/features/core/screens/Settings/navbar.dart';
import 'package:mausam/src/features/core/screens/city_selection/city.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';
import 'package:mausam/src/features/core/screens/dashboard/detail_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCelsius = true; // Default value
  bool isKph = true; // Default value
  bool isLoading = true;

  void onToggleTemperature(bool isCelsius) { // Method to toggle temperature unit
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        this.isCelsius = isCelsius;
      });
      updateUserSettings('selectedTemp', isCelsius); // Update user settings
    });
  }

  void onToggleWind(bool isKph) { // Method to toggle wind speed unit
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        this.isKph = isKph;
      });
      updateUserSettings('selectedWind', isKph); // Update user settings
    });
  }


  final Constants _constants = Constants();
  final authController = Get.put(AuthController());
  final LocationController locationController = Get.put(LocationController());
  static String apiKey = "dfccf20139b94abd8df162403240501";
  TextEditingController cityController = TextEditingController();
  String location = 'Mumbai';
  String weatherIcon = '';
  String weatherImg = '';
  int temperature = 0;
  int temp1 = 0;
  int temp2 = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  int maxtemp_c = 0;
  String currentDate = '';
  String iconMain = '';
  String iconHour = '';


  var  selectedCities = City.getSelectedCities();
  List<String> cities = ['Mumbai'];

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  //String currentWeatherStatus = '';
  String weatherStateName = '';
  String weatherState = 'Maharashtra';
  int weatherStateCode = 0;

  //API Call
  String searchWeatherUrl = 'https://api.weatherapi.com/v1/forecast.json?key='+ apiKey +'&days=7&q=';
  //String searchLocationUrl = 'https://api.weatherapi.com/v1/current.json?key='+ apiKey +'&q=';

//  late Position _currentPosition;
  Future<void> getLoc() async { // Method to get the user's location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true); // Get the user's current position
    var latitude = position.latitude; // Get latitude
    var longitude = position.longitude; // Get longitude
    var add = "$latitude,$longitude"; // Combine latitude and longitude
    fetchWeatherData(add); // Fetch weather data for the location
  }

  /*Future<void> getLoc() async {
    try {
      // Check if location services are enabled
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        // Location services are not enabled, prompt the user to turn them on
        bool serviceStatus = await Geolocator.openLocationSettings();
        if (!serviceStatus) {
          // User did not enable location services, handle it accordingly
          return;
        }
      }

      // Check if the location permission is granted
      if (await Permission.location.isGranted) {
        // Get the user's current position with a timeout of 10 seconds
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true,
          timeLimit: Duration(seconds: 10),
        );
        var latitude = position.latitude;
        var longitude = position.longitude;
        var add = "$latitude,$longitude";
        fetchWeatherData(add);
      } else {
        // Request the location permission
        await Permission.location.request();
        // Recursively call the method again to get the location after permission is granted
        await getLoc();
      }
    } catch (e) {
      print('Error fetching location: $e');
      // Handle the timeout or any other error that occurred while fetching the location
      // You can retry fetching the location or show a message to the user
    }
  }*/

  void fetchWeatherData(String searchText) async { // Method to fetch weather data
    try {
      var searchResult = await http.get(Uri.parse(searchWeatherUrl + searchText)); // Make an HTTP request to get weather data
      final weatherData = Map<String,dynamic>.from(json.decode(searchResult.body) ?? 'No Data'); // Decode the JSON response

      if (weatherData.containsKey('error')) { // Check for error in the response
        ScaffoldMessenger.of(context).showSnackBar( // Show error snackbar
          const SnackBar(content: Text('City not found. Please check the city name and try again.')),
        );
        return;
      }

      var locationData = weatherData["location"]; // Get location data from the response
      var currentWeather = weatherData["current"]; // Get current weather data from the response

      setState(() { // Update the state with the new weather data
        location = getShortLocationName(locationData["name"]);
        var parsedDate = DateTime.parse(locationData["localtime"].substring(0,10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        weatherStateName = currentWeather["condition"]["text"];
        weatherStateCode = currentWeather["condition"]["code"];
        weatherState = locationData["region"];
        weatherImg = currentWeather["condition"]["icon"];
        weatherIcon = weatherStateName.replaceAll(' ', '').toLowerCase();
        temperature = isCelsius ? currentWeather["temp_c"].toInt() : currentWeather["temp_f"].toInt();
        windSpeed = isKph ? currentWeather["wind_kph"].toInt() :currentWeather["wind_mph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        temp1 = weatherData["current"]["temp_c"].toInt();
        temp2 = weatherData["current"]["temp_f"].toInt();
      });
    } catch (e) { // Catch any errors that occur during the fetch operation
      print('Error fetching weather data: $e');
      ScaffoldMessenger.of(context).showSnackBar( // Show error snackbar
        SnackBar(content: Text('Failed to fetch weather data. Please try again later.')),
      );
    }
    //print(maxtemp_c);
    print(weatherIcon);
    print(location);
    print("temp1 : "+temp1.toString());
    print("temp2 "+temp2.toString());
  }

  static String getShortLocationName(String s){
    List<String> wordList = s.split(" ");

    if(wordList.isNotEmpty){
      if(wordList.length > 1){
        return wordList[0] + " "+ wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  Future<void> updateUserSettings(String field, dynamic value) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('UserPreference').doc(user.uid).update({
        field: value,
      });
    }
  }

  Future<void> loadUserSettings() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('UserPreference').doc(user.uid).get();
      print('selectedTemp from Firestore: ${doc.get('selectedTemp')}');
      print('selectedWind from Firestore: ${doc.get('selectedWind')}');

      setState(() {
        isCelsius = doc.get('selectedTemp') ?? 0;
        isKph = doc.get('selectedWind') ?? 0;
        print('isCelsius updated to: $isCelsius');
        print('isKph updated to: $isKph');
      });

    }
  }

  @override
  void initState() {
/*    LocationService.instance.getUserLocation(controller: locationController);
    getLoc();*/
    LocationService.instance.getUserLocation(controller: locationController).then((_) {
      getLoc().then((_) {
        setState(() {
          isLoading = false; // Set loading state to false when data is fetched
        });
      }).catchError((error) {
        setState(() {
          isLoading = false; // Set loading state to false if an error occurs
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching location. Please check your network connection.'),
          ),
        );
      });
    }).catchError((error) {
      setState(() {
        isLoading = false; // Set loading state to false if an error occurs
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching location. Please check your network connection.'),
        ),
      );
    });
    loadUserSettings();
    //getLocation();
    //fetchWeatherData(location);
    print(FirebaseAuth.instance.currentUser?.uid);

   /* for(int i=0; i<selectedCities.length; i++){
      cities.add(selectedCities[i].city);
    }*/


    //selectedCities = City.getSelectedCities();
    //cities = selectedCities.map((city) => city.city).toList();
    // print(cities.toString());
    /*for (final city in selectedCities) {
      fetchWeatherData(city.city);
    }

    */
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }


  Widget build(BuildContext context) {
    // Set the system UI mode to manual
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // Check if dark mode is enabled
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    // Get the screen size
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey, // Assign a global key to the scaffold
        drawer: NavBar(onToggleTemperature: onToggleTemperature, onToggleWind: onToggleWind,), // Add a drawer with temperature and wind toggles
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          backgroundColor: isDarkMode ? Color(0xff0e0231) : Color(0xffcfe3ff), // Set app bar color based on dark mode
          elevation: 0.0,
          title: Text("Today's Weather",style: TextStyle(fontSize: 24,color: _constants.corePrimaryColor)), // Set app bar title
          actions: [
            Row(
              children: [
                // IconButton for city search
                IconButton(onPressed: () {
                  cityController.clear();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: Container(
                        height: size.height *.5,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Divider(
                                thickness: 3.5,
                                color: _constants.corePrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            TextField(
                              onSubmitted: (searchText){
                                fetchWeatherData(searchText);
                                Navigator.pop(context);
                              },
                              controller: cityController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search,color: _constants.corePrimaryColor,),
                                  suffixIcon: GestureDetector(
                                    onTap: ()=> cityController.clear(),
                                    child: Icon(Icons.close,color: _constants.corePrimaryColor,),
                                  ),
                                  hintText: 'Search City (Pune, Maharashtra)',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _constants.corePrimaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }, icon: Icon(Icons.search,color: isDarkMode ? Colors.white : Colors.black,size: 25,)),
              ],
            )
          ],
        ),
        body:isLoading ? // Check loading state
        Center(
          child: CircularProgressIndicator(), // Display circular progress indicator if loading
        ) : Container(
          // Set the background gradient
          decoration: BoxDecoration(
            gradient: isDarkMode ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xff10012a),
                  Color(0xff051779),
                ]
            ) : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffcfe3ff),
                  Color(0xffcfe3ff),
                ]
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display location and state
                Text(location+', '+weatherState,style: const TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold
                )),
                // Display current date
                Text(currentDate,style: TextStyle(
                    fontSize: 16.0,
                    color: isDarkMode ? Color(0xffbdbcbc): Colors.black87
                )),
                const SizedBox(height: 40),
                // Weather information container
                Container(
                  width: size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      color: _constants.corePrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: _constants.corePrimaryColor.withOpacity(0.5),
                          offset: const Offset(0, 25),
                          blurRadius: 10,
                          spreadRadius: -12,
                        )
                      ]
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Positioned widget for weather icon
                      Positioned(
                        top: -40, left: 20,
                        child: weatherIcon == '' ? const Text('') : Image.asset("assets/images/dashboard/"+weatherIcon+".png",width: 150),
                      ),
                      // Positioned widget for weather state name
                      Positioned(
                        bottom: 30, left: 20,
                        child: Text(weatherStateName,softWrap: true, style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold,)),
                      ),
                      // Positioned widget for temperature
                      Positioned(
                        top: 20, right: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(isCelsius ? temp1.toString() : temp2.toString(),
                                style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = _constants.shader
                                ),
                              ),
                            ),
                            Text('o', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, foreground: Paint()..shader = _constants.shader)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Weather details container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Weather item for wind speed
                      weatherItem(text: "Wind Speed",value: windSpeed.toInt(), unit: isKph ?' km/h' : ' m/h', weatherIcon: "assets/images/dashboard/windspeed.png",),
                      // Weather item for humidity
                      weatherItem(text: "Humidity",value: humidity.toInt(), unit: '%', weatherIcon: "assets/images/dashboard/humidity.png",),
                      // Weather item for cloud cover
                      weatherItem(text: "Cloudy",value: cloud.toInt(), unit: '%', weatherIcon: "assets/images/dashboard/cloud.png",),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                // Today's forecast
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Today',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailPage(
                        dailyForecastWeather: dailyWeatherForecast,
                        isCelsius: isCelsius,
                        isKph: isKph,
                        onToggleTemperature: onToggleTemperature,
                        onToggleWind: onToggleWind,
                      ))),
                      child: Text('Forecasts >',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _constants.corePrimaryColor,
                      ),),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                // Hourly weather forecast
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: hourlyWeatherForecast.length,
                    itemBuilder: (BuildContext context, int index){
                      // Get current hour
                      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                      String currentHour = currentTime.substring(0,2);
                      // Get forecast time
                      String forecastTime = hourlyWeatherForecast[index]["time"].substring(11,16);
                      String forecastHour = hourlyWeatherForecast[index]["time"].substring(11,13);
                      String forecastWeatherName = hourlyWeatherForecast[index]["condition"]["text"];
                      String forecastWeatherIcon = forecastWeatherName.replaceAll(' ', '').toLowerCase()+".png";
                      String forecastTemperature = isCelsius ? hourlyWeatherForecast[index]["temp_c"].round().toString() : hourlyWeatherForecast[index]["temp_f"].round().toString();

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        margin: const EdgeInsets.only(right: 20),
                        width: 65,
                        decoration: BoxDecoration(
                            color: currentHour == forecastHour ? Colors.white : _constants.corePrimaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color:_constants.corePrimaryColor.withOpacity(0.2),
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(forecastTime,style: TextStyle(
                              fontSize: 17, color: currentHour == forecastHour ? Colors.black : Colors.white, fontWeight: FontWeight.w600,
                            )),
                            Image.asset('assets/images/dashboard/'+forecastWeatherIcon,width: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(forecastTemperature,style: TextStyle(
                                  color: currentHour == forecastHour ?Colors.black : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                                Text(isCelsius ? "\u2103":"\u2109",style: TextStyle(
                                    color: currentHour == forecastHour ?Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    fontFeatures: const [
                                      FontFeature.enable('sups')
                                    ]
                                ))
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]
          ),
        )
    );
  }
}