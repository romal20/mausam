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
import 'package:mausam/src/features/core/screens/Location/location_services.dart';
import 'package:mausam/src/features/core/screens/Location/search_location.dart';
import 'package:mausam/src/features/core/screens/Settings/navbar.dart';
import 'package:mausam/src/features/core/screens/city_selection/city.dart';
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';
import 'package:mausam/src/features/core/screens/dashboard/detail_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCelsius = true; // Default value
  bool isKph = true; // Default value

  // bool onToggleTemperature(bool isCelsius) {
  //   setState(() {
  //     this.isCelsius = isCelsius;
  //   });
  //   return this.isCelsius;
  // }
  void onToggleTemperature(bool isCelsius) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        this.isCelsius = isCelsius;
      });
      updateUserSettings('selectedTemp', isCelsius);
    });
  }

  void onToggleWind(bool isKph) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        this.isKph = isKph;
      });
      updateUserSettings('selectedWind', isKph);
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
  Future<void> getLoc() async {
    /*Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });*/

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
    print(position);
    var latitude = position.latitude;
    print("Latitude: " + position.latitude.toString());
    var longitude = position.longitude;
    print("Longitude: " + position.longitude.toString());
    var add = "$latitude,$longitude";
    fetchWeatherData(add);
  }

/*  late String _currentAddress;
  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude,
          _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
        print("A: "+_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }*/

  void fetchWeatherData(String searchText) async{
    try{
      var searchResult = await http.get(Uri.parse(searchWeatherUrl + searchText));
      final weatherData = Map<String,dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');

      if (weatherData.containsKey('error')) {
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('City not found. Please check the city name and try again.')),
        );
        return;
      }

      //print(weatherData);

      var locationData = weatherData["location"];
      //print(locationData);
      var currentWeather = weatherData["current"];
      //print(currentWeather);

      //dailyWeatherForecast = weatherData["forecast"]["forecastday"];
      // print("Daily: "+dailyWeatherForecast.toString());
      //hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
      // print("Hourly: "+hourlyWeatherForecast.toString());
      //  print(weatherData["forecast"]["forecastday"]["day"]["maxtemp_c"]);

      setState(() {
        location = getShortLocationName(locationData["name"]);
        var parsedDate = DateTime.parse(locationData["localtime"].substring(0,10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        weatherStateName = currentWeather["condition"]["text"];
        weatherStateCode = currentWeather["condition"]["code"];
        weatherState = locationData["region"];
        weatherImg = currentWeather["condition"]["icon"];
        weatherIcon = weatherStateName.replaceAll(' ', '').toLowerCase();
        temperature = isCelsius ? currentWeather["temp_c"].toInt() : currentWeather["temp_f"].toInt();//currentWeather["temp_c"].toInt();
        windSpeed = isKph ? currentWeather["wind_kph"].toInt() :currentWeather["wind_mph"].toInt();
        print('Temperature value: '+temperature.toString());
        print('Wind value: '+windSpeed.toString());

        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        temp1 = weatherData["current"]["temp_c"].toInt();
        temp2 = weatherData["current"]["temp_f"].toInt();
      });

    } catch (e) {
      print('Error fetching weather data: $e');
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch weather data. Please try again later.')),
      );
    }
    //print(maxtemp_c);
    print(weatherIcon);
    print(location);
    print("temp1 : "+temp1.toString());
    print("temp2 "+temp2.toString());
  }

  /*void updateTemperatureUnit(bool isCelsius) {
    setState(() {
      this.isCelsius = isCelsius;
      print("Home: "+isCelsius.toString());
    });
  }*/

 /* void getLocation() async {

      //LocationService.instance.getUserLocation(controller: locationController);

    // Wait for the userLocation to be updated
    // await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

    *//*var lat = locationController.userLocation.value?.latitude;
    var lon = locationController.userLocation.value?.longitude;
    loc = lat.toString() + ',' + lon.toString();
    print(loc);*//*
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
    print(position);
    var latitude = position.latitude;
    print("Latitude: " + position.latitude.toString());
    var longitude = position.longitude;
    print("Longitude: " + position.longitude.toString());
    var loc = "$latitude,$longitude";
    fetchWeatherData(loc);
  }*/


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
      getLoc();
    }).catchError((error) {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      drawer: NavBar(onToggleTemperature: onToggleTemperature, onToggleWind: onToggleWind,),
        //onToggle: _updateIsCelsius,
      //backgroundColor: isDarkMode ? Color(0xff10012a) : Colors.white,//0xffa379ec
      //backgroundColor: Colors.white
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: isDarkMode ? Color(0xff0e0231) : Color(0xffcfe3ff),
        elevation: 0.0,
        title: Text("Today's Weather",style: TextStyle(fontSize: 24,color: _constants.corePrimaryColor)),
        actions: [
          Row(
            children: [
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   width: size.width,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
                    IconButton(onPressed: (){
                      cityController.clear();
                      showModalBottomSheet(context: context, builder: (context)=>SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: Container(
                          height: size.height *.5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,vertical: 10
                          ),
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
/*                          onChanged: (searchText){
                            fetchWeatherData(searchText);
                          },*/controller: cityController,
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
                      ));
                    }, icon: Icon(Icons.search,color: isDarkMode ? Colors.white : Colors.black,size: 25,)),
                    //Profile Image
                    //Location Dropdown
                    /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Icon(Icons.location_on_outlined,color: isDarkMode ? Colors.white : Colors.black,weight: 20,),
                  //Image.asset("assets/images/dashboard/pin.png",width: 20,color: Colors.blue,),
                  *//*DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: location,
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: isDarkMode? Color(0xff0e0231) : Color(0xffcfe3ff),
                        menuMaxHeight: 175,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cities.map((String location){
                          return DropdownMenuItem(
                              value: location,
                              child: Text(location));
                        }).toList(),
                        onChanged: (String? newValue){
                          setState(() {
                            location = newValue!;
                            fetchWeatherData(location);
                          });
                        }
                    ),
                  )*//*
                  *//*IconButton(
                    color: Colors.white,
                    onPressed: () {
                      cityController.clear();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: Container(
                            height: size.height * .5,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
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
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: cities.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(cities[index]),
                                        onTap: () {
                                          setState(() {
                                            location = cities[index];
                                          });
                                          fetchWeatherData(location);
                                          Navigator.pop(context); // Close the modal
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.search, color: Colors.black, size: 25),
                  ),*//*
                ],
              )*/
                  ],


          )
        ],
        //title:
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: isDarkMode ? const LinearGradient(
            //center: Alignment.center,
            //radius: 1,
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff10012a),//0xff051779,0xff000ea1,0xff6696f5
              Color(0xff051779),//0xff10012a
            //Color(0xff1520a6),
            //(0xffaac4f3),
            ]) :
            const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffcfe3ff),
              Color(0xffcfe3ff),

              //Color(0xfffafaff)
              /*Color(0x8eeefcff),
              Color(0x8ed3f9fd),
              Color(0x8eeefcff),*/
            ]),),
        padding: const EdgeInsets.all(20),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Text(location+', '+weatherState,style: const TextStyle(
                    fontSize: 26.0,      //30
                    fontWeight: FontWeight.bold
                )),
                Text(currentDate,style: TextStyle(
                    fontSize: 16.0,       //16
                    color: isDarkMode ? Color(0xffbdbcbc): Colors.black87
                )),

                const SizedBox(height: 40),
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
                      Positioned(
                        top: -40, left: 20,
                        child: weatherIcon == '' ? const Text('') : Image.asset("assets/images/dashboard/"+weatherIcon+".png",width: 150),
                      ),
                      Positioned(
                        bottom: 30, left: 20,
                        child: Text(weatherStateName,softWrap: true, style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold,)),   //20
                      ),
                      Positioned(
                        top: 20, right: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(isCelsius ? temp1.toString() : temp2.toString(),//temperature.toString(),
                                  style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()..shader = _constants.shader)),
                            ),
                            Text('o', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, foreground: Paint()..shader = _constants.shader)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      weatherItem(value: windSpeed.toInt(), unit: isKph ?' km/h' : ' m/h', weatherIcon: "assets/images/dashboard/windspeed.png",),
                      weatherItem(value: humidity.toInt(), unit: '%', weatherIcon: "assets/images/dashboard/humidity.png",),
                      weatherItem(value: cloud.toInt(), unit: '%', weatherIcon: "assets/images/dashboard/cloud.png",),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Today',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,      //24
                    ),),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailPage(
                        dailyForecastWeather: dailyWeatherForecast,
                        isCelsius: isCelsius,
                        isKph: isKph,
                        onToggleTemperature: onToggleTemperature,
                      onToggleWind: onToggleWind,
                      ))),//(isCelsius)
                      child: Text('Forecasts >',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,   //24
                        color: _constants.corePrimaryColor,
                      ),),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                // Column(
                //   children: [
                //     Text(hourlyWeatherForecast.length.toString()),
                //     Text(dailyWeatherForecast.length.toString()),
                //   ],
                // ),
                Expanded(
                  child: ListView.builder(
                    //shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: hourlyWeatherForecast.length,
                    itemBuilder: (BuildContext context, int index){
                      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                      String currentHour = currentTime.substring(0,2);
                      String forecastTime = hourlyWeatherForecast[index]["time"].substring(11,16);
                      String forecastHour = hourlyWeatherForecast[index]["time"].substring(11,13);
                      String forecastWeatherName = hourlyWeatherForecast[index]["condition"]["text"];
                      //String forecastWeatherImg = hourlyWeatherForecast[index]["condition"]["icon"];
                       String forecastWeatherIcon = forecastWeatherName.replaceAll(' ', '').toLowerCase()+".png";
                      String forecastTemperature = isCelsius ? hourlyWeatherForecast[index]["temp_c"].round().toString() : hourlyWeatherForecast[index]["temp_f"].round().toString();//hourlyWeatherForecast[index]["temp_c"].round().toString();

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        margin: const EdgeInsets.only(right: 20),    //,bottom: 10,top: 10),
                        width: 65,  //80,
                        decoration: BoxDecoration(
                            color: currentHour == forecastHour ? Colors.white : _constants.corePrimaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color:_constants.corePrimaryColor.withOpacity(0.2),//currentHour == forecastHour ? myConstants.corePrimaryColor : Colors.black54.withOpacity(0.2), //
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
                                Text("\u2103",style: TextStyle(         //  \u2103 = Unicode Character degree symbol
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