import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mausam/src/common_widgets/weather_item/weather_item.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/core/screens/dashboard/weather.dart';
import 'package:mausam/src/features/core/screens/dashboard/weather_service.dart';

import '../city_selection/city.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Constants myConstants = Constants();

  static String apiKey = "dfccf20139b94abd8df162403240501";

  String location = 'Mumbai';
  String weatherIcon = 'assets/images/dashboard/cloud.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  int maxTemp = 0;
  String currentDate = '';

  var  selectedCities = City.getSelectedCities();
  List<String> cities = ['Mumbai'];

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  //String currentWeatherStatus = '';
  String weatherStateName = '';

  //API Call
  String searchWeatherUrl = 'https://api.weatherapi.com/v1/forecast.json?key='+ apiKey +'&days=7&q=';
  //String searchLocationUrl = 'https://api.weatherapi.com/v1/current.json?key='+ apiKey +'&q=';

  void fetchWeatherData(String searchText) async{
    try{
      var searchResult = await http.get(Uri.parse(searchWeatherUrl + searchText));
      final weatherData = Map<String,dynamic>.from(
        json.decode(searchResult.body) ?? 'No Data');

      //print(weatherData);

      var locationData = weatherData["location"];
      //print(locationData);
      var currentWeather = weatherData["current"];
      //print(currentWeather);

      List<dynamic> dailyWeatherForecast = weatherData["forecast"]["forecastday"][0];
      print(dailyWeatherForecast);
      List<dynamic> hourlyWeatherForecast = weatherData["forecast"]["forecastday"][0]["hour"];
      print(hourlyWeatherForecast);
      print(hourlyWeatherForecast.toString());

      setState(() {
        location = getShortLocationName(locationData["name"]);
        var parsedDate = DateTime.parse(locationData["localtime"].substring(0,10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        //Update Weather
        weatherStateName = currentWeather["condition"]["text"];
        weatherIcon = weatherStateName.replaceAll(' ', '').toLowerCase()+".png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();
        maxTemp = currentWeather["max_temp"].toInt();

        //Forecast Data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"][0];
        hourlyWeatherForecast = weatherData["forecast"]["forecastday"][0]["hour"]; // dailyWeatherForecast[0]["hour"];

        print(dailyWeatherForecast);
        print(hourlyWeatherForecast);
      });
      //print(currentWeather);


    } catch(e){
      //debugPrint(e)
    }
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

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();

    for(int i=0; i<selectedCities.length; i++){
      cities.add(selectedCities[i].city);
    }

  }

  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Profile Image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(profileImage,width: 40,height: 40,),
              ),

              //Location Dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/dashboard/pin.png",width: 20,color: Colors.blue,),
                  const SizedBox(width: 4,),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: location,
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dailyWeatherForecast.toString()),
            Text(hourlyWeatherForecast.toString()),
            Text(location,style: const TextStyle(
              fontSize: 26.0,      //30
              fontWeight: FontWeight.bold
            )),
            Text(currentDate,style: const TextStyle(
              fontSize: 14.0,        //16
              color: Colors.grey
            )),
            const SizedBox(height: 50),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                color: myConstants.corePrimaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: myConstants.corePrimaryColor.withOpacity(0.5),
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
                    child: weatherIcon == '' ? const Text('') : Image.asset("assets/images/dashboard/$weatherIcon",width: 150),
                  ),
                  Positioned(
                    bottom: 30, left: 20,
                    child: Text(weatherStateName,softWrap: true, style: const TextStyle(color: Colors.white, fontSize: 17)),   //20
                  ),
                  Positioned(
                    top: 20, right: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                          child: Text(temperature.toString(),
                            style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = myConstants.shader)),
                        ),
                        Text('o', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, foreground: Paint()..shader = myConstants.shader)),
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
                  weatherItem(value: windSpeed, text: 'Wind Speed', unit: ' km/h', weatherIcon: "assets/images/dashboard/windspeed.png",),
                  weatherItem(value: humidity, text: 'Humidity', unit: '', weatherIcon: "assets/images/dashboard/humidity.png",),
                  weatherItem(value: maxTemp, text: 'Max Temperature', unit: 'C', weatherIcon: "assets/images/dashboard/max-temp.png",),
                ],
              ),
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Today',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,      //24
                ),),
                Text('Next 7 Days',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,   //24
                  color: myConstants.corePrimaryColor,
                ),)
              ],
            ),
            const SizedBox(height: 20,),
            /*Column(
              children: [
                Text(hourlyWeatherForecast.toString()),
                Text(dailyWeatherForecast.toString()),
              ],
            ),*/
            Expanded(
              child: ListView.builder(
                //shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: hourlyWeatherForecast.length,
                    itemBuilder: (BuildContext context, int index){
                      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                      String currentHour = currentTime.substring(0,2);
                      String forecastTime = hourlyWeatherForecast[index]["time"].substring(11,16);
                      String forecastHour = hourlyWeatherForecast[index]["time"].substring(11,13);
                      String forecastWeatherName = hourlyWeatherForecast[index]["condition"]["text"];
                      String forecastWeatherIcon = forecastWeatherName.replaceAll(' ', '').toLowerCase()+".png";
                      String forecastTemperature = hourlyWeatherForecast[index]["temp_c"].round().toString();

                      print(hourlyWeatherForecast.length);
                      print(currentTime);
                      print(currentHour);
                      print(forecastTime);
                      print(forecastHour);
                      print(forecastWeatherName);
                      print(forecastWeatherIcon);
                      print(forecastTemperature);

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        margin: const EdgeInsets.only(right: 20),    //,bottom: 10,top: 10),
                        width: 65,  //80,
                        decoration: BoxDecoration(
                          color: currentHour == forecastHour ? Colors.white : myConstants.corePrimaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color:myConstants.corePrimaryColor.withOpacity(0.2),//currentHour == forecastHour ? myConstants.corePrimaryColor : Colors.black54.withOpacity(0.2), //
                            )
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(forecastTime,style: TextStyle(
                              fontSize: 17, color: myConstants.greyColor, fontWeight: FontWeight.w500,
                            ),),
                            Image.asset('assets/images/dashboard/'+forecastWeatherIcon,width: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(forecastTemperature,style: TextStyle(
                                  color: myConstants.greyColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),),
                                Text('o',style: TextStyle(
                                  color: myConstants.greyColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  fontFeatures: const [
                                    FontFeature.enable('sups')
                                  ]
                                ),)
                              ],
                            )
                          ],
                        ),
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}