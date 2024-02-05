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
import 'package:mausam/src/features/core/screens/dashboard/detail_page.dart';
import '../city_selection/city.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Constants _constants = Constants();

  static String apiKey = "dfccf20139b94abd8df162403240501";

  String location = 'Mumbai';
  String weatherIcon = '';
  String weatherImg = '';
  int temperature = 0;
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
  int weatherStateCode = 0;

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
        weatherImg = currentWeather["condition"]["icon"];
        weatherIcon = weatherStateName.replaceAll(' ', '').toLowerCase();
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
      });

    } catch(e){
      //debugPrint(e)
    }
    //print(maxtemp_c);
    //print(weatherIcon);
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
                child: Image.network(profileImage,width: 40,height: 40,),
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
            Text(location,style: const TextStyle(
                fontSize: 26.0,      //30
                fontWeight: FontWeight.bold
            )),
            Text(currentDate,style: const TextStyle(
                fontSize: 14.0,        //16
                color: Colors.grey
            )),

            const SizedBox(height: 60),
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
                          child: Text(temperature.toString(),
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
                  weatherItem(value: windSpeed.toInt(), unit: ' km/h', weatherIcon: "assets/images/dashboard/windspeed.png",),
                  weatherItem(value: humidity.toInt(), unit: '%', weatherIcon: "assets/images/dashboard/humidity.png",),
                  weatherItem(value: cloud.toInt(), unit: '%', weatherIcon: "assets/images/dashboard/cloud.png",),
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
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailPage(dailyForecastWeather: dailyWeatherForecast))),
                  child: Text('Forecasts >',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,   //24
                    color: _constants.corePrimaryColor,
                  ),),
                ),
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
                  String forecastTemperature = hourlyWeatherForecast[index]["temp_c"].round().toString();

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
                          fontSize: 17, color: _constants.greyColor, fontWeight: FontWeight.w500,
                        )),
                        Image.asset('assets/images/dashboard/'+forecastWeatherIcon,width: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(forecastTemperature,style: TextStyle(
                              color: _constants.greyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                            Text("\u2103",style: TextStyle(         //  \u2103 = Unicode Character degree symbol
                                color: _constants.greyColor,
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
          ],
        ),
      ),
    );
  }
}