import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/authentication/controllers/auth_controller.dart';
import 'package:mausam/src/features/core/screens/city_selection/city.dart';
import 'package:http/http.dart' as http;
import 'package:mausam/src/features/core/screens/city_selection/city_option.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Initialization
  //int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading...';
  int humidity = 0;
  int windSpeed = 0;

  var currentDate = 'Loading...';
  String imageUrl = '';
  int woeid = 44418;    //This is the Where on earth ID for Mumbai which is our default city
  double latitude = 18.98;   //Default city latitude
  double longitude = 72.83;    //Default city longitude
  String locationName = 'Mumbai';        //Default City

  //Get the City and Selected Cities Data
  var selectedCities = City.getSelectedCities();
  List<String> cities = ['Mumbai'];      //The list to hold our selected cities. Default is Mumbai

  //List consolidatedWeatherList = [];    //To hold our weather data after api call.
  String currentWeatherStatus = '';
  //Api calls url
  static String apiKey = "dfccf20139b94abd8df162403240501";
  String searchLocationUrl = 'https://api.weatherapi.com/v1/current.json?key='+ apiKey +'&q='; // To find woeid (i.e. latitude and longitude)
  String searchWeatherUrl = 'https://api.weatherapi.com/v1/forecast.json?key='+ apiKey +'&q='; //To get weather details using woeid
  //Get the woeid
  void fetchLocation(String locationName) async{
      var searchResult = await http.get(Uri.parse(searchLocationUrl + locationName));
      var result = json.decode(searchResult.body)['location'];
      setState(() {
        latitude = result["location"]["lat"];
        longitude = result["location"]["lon"];  
      });

      //print(result);
      //print("Latitude: $latitude");
      //print("Longitude: $longitude");
      //print(result["lat"]);
      //print(result["lon"]);
  }


  void fetchWeatherData() async{
    //List<Map<String, dynamic>> consolidatedWeather = [];
    var weatherResult = await http.get(Uri.parse(searchWeatherUrl + latitude.toString()+','+longitude.toString()));
    //var result = Map<String,dynamic>.from(json.decode(weatherResult.body));
    var result = json.decode(weatherResult.body);
    //consolidatedWeather.add(Map<String, dynamic>.from(result));    //result['location'];
    var consolidatedWeather = result; //result['location'];

    print(consolidatedWeather);
    setState(() {
      for(int i=0; i<7; i++){
        consolidatedWeather.add(consolidatedWeather[i]);    //This takes the consolidated weather for the next six days for the location searched
      }
    });

    //int temperature = int.parse(consolidatedWeather['current']['temp_c'].round());
    //weatherStateName = consolidatedWeather['current']['condition']['text'];
    //print(consolidatedWeather['location']);
    //print(temperature);
  }

  @override
  void initState() {
    fetchLocation(cities[0]);
    fetchWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          Container(
            child: IconButton(
                onPressed: () async {
                  await Get.put(AuthController()).signOutMethod(context);
                  Get.offAll(() => const CityOption());
                },
                icon: const Icon(Icons.arrow_back)),
          )
        ],
      ),
    );
  }
}
