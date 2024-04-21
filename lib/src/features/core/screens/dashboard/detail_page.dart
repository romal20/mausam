import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mausam/src/common_widgets/weather_item/weather_item.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/features/core/screens/Settings/navbar.dart';

class DetailPage extends StatefulWidget {
  final dailyForecastWeather; // Daily forecast weather data
  final isCelsius; // Flag for temperature unit (Celsius or Fahrenheit)
  final isKph; // Flag for wind speed unit (Kph or Mph)
  final onToggleTemperature; // Callback for temperature unit toggle
  final onToggleWind; // Callback for wind speed unit toggle

  const DetailPage({Key? key, this.dailyForecastWeather, this.isCelsius, this.isKph, this.onToggleTemperature, this.onToggleWind}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Constants _constants = Constants();

  /*bool isCelsius = true; // Default value

  void onToggleTemperature(bool isCelsius) {
    setState(() {
      this.isCelsius = isCelsius;
    });
  }*/


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get screen size
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark; // Check if dark mode is enabled
    var weatherData = widget.dailyForecastWeather; // Get daily forecast weather data
    print(weatherData); // Print weather data to console

    //Function to get weather
    Map getForecastWeather(int index){ // Function to extract forecast weather data
      int maxWindSpeed = widget.isKph ? weatherData[index]["day"]["maxwind_kph"].toInt() : weatherData[index]["day"]["maxwind_mph"].toInt(); // Get maximum wind speed
      int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt(); // Get average humidity
      int chanceOfRain = weatherData[index]["day"]["daily_chance_of_rain"].toInt(); // Get chance of rain

      var parsedDate = DateTime.parse(weatherData[index]["date"]); // Parse date string to DateTime
      var forecastDate = DateFormat('EEE, d MMM').format(parsedDate); // Format forecast date

      String weatherName = weatherData[index]["day"]["condition"]["text"]; // Get weather condition name
      String weatherIcon = weatherData[index]["day"]["condition"]["text"].toString().replaceAll(' ', '').toLowerCase() + ".png"; // Get weather icon URL
      int minTemperature = widget.isCelsius ? weatherData[index]["day"]["mintemp_c"].toInt() : weatherData[index]["day"]["mintemp_f"].toInt(); // Get minimum temperature
      int maxTemperature = widget.isCelsius ? weatherData[index]["day"]["maxtemp_c"].toInt() : weatherData[index]["day"]["maxtemp_f"].toInt(); // Get maximum temperature

      var forecastData = { // Create forecast data map
        'maxWindSpeed' : maxWindSpeed,
        'avgHumidity' : avgHumidity,
        'chanceOfRain' : chanceOfRain,
        'forecastDate' : forecastDate,
        'weatherName' : weatherName,
        'weatherIcon' : weatherIcon,
        'minTemperature' : minTemperature,
        'maxTemperature' : maxTemperature
      };
      return forecastData; // Return forecast data
    }

    //print(getForecastWeather(0));
    return Scaffold( // Return a Scaffold widget
      //drawer: NavBar(onToggleTemperature: onToggleTemperature),
      backgroundColor: isDarkMode ? Color(0xff143079) : _constants.corePrimaryColor, // Set background color based on dark mode
      appBar: AppBar( // AppBar widget
        title: Text('Forecasts',style: TextStyle( // AppBar title
            fontSize: 24,
            color: Colors.white
        )),
        automaticallyImplyLeading: false, // Don't show back button
        centerTitle: true, // Center align title
        backgroundColor: isDarkMode ?  Color(0xff143079) : _constants.corePrimaryColor, // Set app bar background color based on dark mode
        elevation: 0.0, // No elevation
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back),color: Colors.white,), // Add back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),

            /*child: IconButton(onPressed: (){
          Get.to(() =>NavBar(onToggleTemperature: widget.onToggleTemperature(!widget.isCelsius)));
          //Get.to(() => NavBar(onToggleTemperature: ));
          }, icon: Icon(Icons.settings,color: Colors.white))*/
          )
        ],
      ),
      body: Stack( // Stack widget for stacking widgets
        alignment: Alignment.center, // Center align stack
        clipBehavior: Clip.none, // Clip overflow behavior
        children: [
          Positioned( // Positioned widget for positioning child widget
              top: 100, left: 0, // Position from top and left
              child: Container( // Container widget
                height: size.height, // Set container height
                width: size.width, // Set container width
                decoration: BoxDecoration( // Container decoration
                  gradient: isDarkMode ? const LinearGradient( // Gradient based on dark mode
                    //center: Alignment.center,
                    //radius: 1,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff10012a),//0xff051779,0xff000ea1
                        Color(0xff10012a)
                        //Color(0xff1520a6),
                        //(0xffaac4f3),
                      ]) :
                  const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffffffff),//Color(0xffa9c1f5),
                        Color(0xffffffff),//Color(0xff6696f5),0xff4277e0,0xff183f8c,0xff4988fa
                      ]),
                  //color: isDarkMode ? Colors.grey.shade50 : Colors.white,  //Color(0xffd9d9d9)
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Stack( // Stack inside container for stacking widgets
                  clipBehavior: Clip.none, // Clip overflow behavior
                  children: [
                    Positioned( // Positioned widget for positioning child widget
                        top: -50, right: 20, left: 20, // Position from top, right, and left
                        child: Container( // Container widget
                            height: 300, // Set container height
                            width: size.width * 0.7, // Set container width
                            decoration: BoxDecoration( // Container decoration
                              gradient: isDarkMode ? _constants.linearGradientBlue : // Gradient based on dark mode
                              const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.center,
                                  colors: [
                                    Color(0xffa9c1f5),//Color(0xffa9c1f5),
                                    Color(0xff6696f5)//Color(0xff6696f5),0xff4277e0,0xff183f8c
                                  ]),
                              boxShadow:[
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  offset: const Offset(0, 25),
                                  blurRadius: 3,
                                  spreadRadius: -10,
                                )],
                              borderRadius: BorderRadius.circular(15), // Set container border radius
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned( // Positioning the weather icon
                                  top: 10, // Distance from the top
                                  left: 10, // Distance from the left
                                  child: Image.asset("assets/images/dashboard/"+getForecastWeather(0)["weatherIcon"]), // Weather icon image
                                  width: 120, // Width of the image
                                ),
                                Positioned( // Positioning the weather name text
                                  top: 140, // Distance from the top
                                  left: 20, // Distance from the left
                                  child: Padding( // Adding padding around the text
                                    padding: const EdgeInsets.only(bottom: 10.0), // Padding at the bottom
                                    child: Text( // Text widget
                                      getForecastWeather(0)["weatherName"], // Weather name text
                                      style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold), // Text style
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  child: Container(
                                    width: size.width * 0.9, // Adjusted width
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        weatherItem(
                                          value: getForecastWeather(0)["maxWindSpeed"],
                                          unit: widget.isKph ?" km/h" : " m/h",
                                          weatherIcon: "assets/images/dashboard/windspeed.png",
                                          text: 'Wind Speed',
                                        ),
                                        weatherItem(
                                          value: getForecastWeather(0)["avgHumidity"],
                                          unit: "%",
                                          weatherIcon: "assets/images/dashboard/humidity.png",
                                          text: 'Humidity',
                                        ),
                                        weatherItem(
                                          value: getForecastWeather(0)["chanceOfRain"],
                                          unit: "%",
                                          weatherIcon: "assets/images/dashboard/lightrain.png",
                                          text: 'Chances of Rain',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Positioned( // Positioning the current temperature
                                  top: 20, // Distance from the top
                                  right: 20, // Distance from the right
                                  child: Row( // Row for current temperature
                                    crossAxisAlignment: CrossAxisAlignment.start, // Aligning items at the start of the row
                                    children: [
                                      Text( // Text widget for displaying the current temperature
                                        getForecastWeather(0)["maxTemperature"].toString(), // Current temperature value
                                        style: TextStyle( // Text style
                                          fontSize: 90, // Font size
                                          fontWeight: FontWeight.bold, // Font weight
                                          foreground: Paint()..shader = _constants.shader, // Text color with shader
                                        ),
                                      ),
                                      Text( // Text widget for degree symbol
                                        'o', // Degree symbol
                                        style: TextStyle( // Text style
                                          fontSize: 40, // Font size
                                          fontWeight: FontWeight.bold, // Font weight
                                          foreground: Paint()..shader = _constants.shader, // Text color with shader
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 330, // Position from the top of the parent widget
                                  child: SizedBox(
                                    height: 400, // Height of the widget
                                    width: size.width * 0.9, // Width of the widget (90% of the screen width)
                                    child: ListView(
                                      scrollDirection: Axis.vertical, // Scroll direction of the list view
                                      physics: const BouncingScrollPhysics(), // Bouncing scroll physics
                                      children: [
                                        Card(
                                          color: isDarkMode ? Color(0xff6696f5) : Colors.white, // Card color based on dark mode
                                          elevation: 3.0, // Elevation of the card
                                          margin: const EdgeInsets.only(bottom: 20), // Margin around the card
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0), // Padding inside the card
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround, // Align children vertically in the column
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children horizontally
                                                  crossAxisAlignment: CrossAxisAlignment.center, // Align children vertically
                                                  children: [
                                                    Text(
                                                      getForecastWeather(0)["forecastDate"], // Display forecast date
                                                      style: TextStyle(
                                                        color: isDarkMode ? Colors.white : Color(0xff6696f5), // Text color based on dark mode
                                                        fontWeight: FontWeight.w600, // Text weight
                                                        fontSize: 18, // Font size
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              getForecastWeather(0)["minTemperature"].toString(), // Display min temperature
                                                              style: TextStyle(
                                                                color: isDarkMode ? Colors.grey.shade300 : Color(0xff9e9e9e), // Text color based on dark mode
                                                                fontSize: 30, // Font size
                                                                fontWeight: FontWeight.w600, // Text weight
                                                              ),
                                                            ),
                                                            Text(
                                                              '\u00B0', // Unicode for degree symbol
                                                              style: TextStyle(
                                                                color: isDarkMode ? Colors.grey.shade300 : Color(0xff9e9e9e), // Text color based on dark mode
                                                                fontSize: 30, // Font size
                                                                fontWeight: FontWeight.w600, // Text weight
                                                                fontFeatures: const [FontFeature.enable('sups')], // Enable superscript for the degree symbol
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          getForecastWeather(0)["maxTemperature"].toString(), // Display max temperature
                                                          style: TextStyle(
                                                            color: isDarkMode ? Colors.grey.shade300 : _constants.blackColor, // Text color based on dark mode
                                                            fontSize: 30, // Font size
                                                            fontWeight: FontWeight.w600, // Text weight
                                                          ),
                                                        ),
                                                        Text(
                                                          '\u00B0', // Unicode for degree symbol
                                                          style: TextStyle(
                                                            color: isDarkMode ? Colors.grey.shade300 : _constants.blackColor, // Text color based on dark mode
                                                            fontSize: 30, // Font size
                                                            fontWeight: FontWeight.w600, // Text weight
                                                            fontFeatures: const [FontFeature.enable('sups')], // Enable superscript for the degree symbol
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10,), // Empty space
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children horizontally
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center, // Align children horizontally
                                                      children: [
                                                        Image.asset("assets/images/dashboard/"+getForecastWeather(0)["weatherIcon"],width: 30,), // Weather icon
                                                        const SizedBox(width: 5,), // Empty space
                                                        Text(
                                                          getForecastWeather(0)["weatherName"], // Display weather name
                                                          style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.grey.shade100 :Colors.grey), // Text style
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center, // Align children horizontally
                                                      children: [
                                                        Text(
                                                          getForecastWeather(0)["chanceOfRain"].toString() + "%", // Display chance of rain
                                                          style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.grey.shade100 : Colors.grey), // Text style
                                                        ),
                                                        Image.asset("assets/images/dashboard/lightrain.png",width: 30,), // Rain icon
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                            color: isDarkMode ? Color(
                                                0xff4265b2) : Colors.white,
                                            elevation: 3.0,
                                            margin: const EdgeInsets.only(bottom: 20),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(getForecastWeather(1)["forecastDate"],style: TextStyle(
                                                          color: isDarkMode ? Colors.white : Color(0xff6696f5),
                                                          fontWeight: FontWeight.w600,fontSize: 18
                                                      )),
                                                      Row(
                                                        children: [
                                                          Row(
                                                              children: [
                                                                Text(getForecastWeather(1)["minTemperature"].toString(),
                                                                    style: TextStyle(
                                                                        color: isDarkMode ? Colors.grey.shade300 :Color(0xff9e9e9e),
                                                                        fontSize: 30,
                                                                        fontWeight: FontWeight.w600
                                                                    )),
                                                                Text('\u00B0',
                                                                    style: TextStyle(
                                                                        color:isDarkMode ? Colors.grey.shade300 : Color(0xff9e9e9e),
                                                                        fontSize: 30,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFeatures: const [
                                                                          FontFeature.enable('sups'),
                                                                        ])),
                                                              ]),
                                                        ],
                                                      ),
                                                      Row(
                                                          children: [
                                                            Text(getForecastWeather(1)["maxTemperature"].toString(),
                                                                style: TextStyle(
                                                                    color: isDarkMode ? Colors.grey.shade300 : _constants.blackColor,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.w600
                                                                )),
                                                            Text('\u00B0',
                                                                style: TextStyle(
                                                                    color: isDarkMode ? Colors.grey.shade300 : _constants.blackColor,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFeatures: const [
                                                                      FontFeature.enable('sups'),
                                                                    ])),
                                                          ]),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Image.asset("assets/images/dashboard/"+getForecastWeather(1)["weatherIcon"],width: 30,),
                                                          const SizedBox(width: 5,),
                                                          Text(getForecastWeather(1)["weatherName"],
                                                            style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.grey.shade100 :Colors.grey),)
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(getForecastWeather(1)["chanceOfRain"].toString() + "%",
                                                            style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.grey.shade100 : Colors.grey),),
                                                          Image.asset("assets/images/dashboard/lightrain.png",width: 30,),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        Card(
                                            color: isDarkMode ? Color(
                                                0xff143079) : Colors.white,
                                            elevation: 3.0,
                                            margin: const EdgeInsets.only(bottom: 20),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(getForecastWeather(2)["forecastDate"],style: TextStyle(
                                                          color: isDarkMode ? Colors.white : Color(0xff6696f5),
                                                          fontWeight: FontWeight.w600,fontSize: 18
                                                      )),
                                                      Row(
                                                        children: [
                                                          Row(
                                                              children: [
                                                                Text(getForecastWeather(2)["minTemperature"].toString(),
                                                                    style: TextStyle(
                                                                        color: isDarkMode ? Colors.grey.shade300 :Color(0xff9e9e9e),
                                                                        fontSize: 30,
                                                                        fontWeight: FontWeight.w600
                                                                    )),
                                                                Text('\u00B0',
                                                                    style: TextStyle(
                                                                        color:isDarkMode ? Colors.grey.shade300 : Color(0xff9e9e9e),
                                                                        fontSize: 30,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFeatures: const [
                                                                          FontFeature.enable('sups'),
                                                                        ])),
                                                              ]),
                                                        ],
                                                      ),
                                                      Row(
                                                          children: [
                                                            Text(getForecastWeather(2)["maxTemperature"].toString(),
                                                                style: TextStyle(
                                                                    color: isDarkMode ? Colors.grey.shade300 : _constants.blackColor,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.w600
                                                                )),
                                                            Text('\u00B0',
                                                                style: TextStyle(
                                                                    color: isDarkMode ? Colors.grey.shade300 : _constants.blackColor,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFeatures: const [
                                                                      FontFeature.enable('sups'),
                                                                    ])),
                                                          ]),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Image.asset("assets/images/dashboard/"+getForecastWeather(2)["weatherIcon"],width: 30,),
                                                          const SizedBox(width: 5,),
                                                          Text(getForecastWeather(2)["weatherName"],
                                                            style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.grey.shade100 :Colors.grey),)
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(getForecastWeather(2)["chanceOfRain"].toString() + "%",
                                                            style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.grey.shade100 : Colors.grey),),
                                                          Image.asset("assets/images/dashboard/lightrain.png",width: 30,),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
