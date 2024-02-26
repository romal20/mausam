import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mausam/src/common_widgets/weather_item/weather_item.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/features/core/screens/Settings/navbar.dart';

import '../profile/profile_screen.dart';

class DetailPage extends StatefulWidget {
  final dailyForecastWeather;
  final isCelsius;
  final onToggleTemperature;

  const DetailPage({Key? key, this.dailyForecastWeather, this.isCelsius, this.onToggleTemperature}) : super(key: key);

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
    Size size = MediaQuery.of(context).size;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var weatherData = widget.dailyForecastWeather;
    print(weatherData);
    
    //Function to get weather
    Map getForecastWeather(int index){
      int maxWindSpeed = weatherData[index]["day"]["maxwind_kph"].toInt();
      int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt();
      int chanceOfRain = weatherData[index]["day"]["daily_chance_of_rain"].toInt();

      var parsedDate = DateTime.parse(weatherData[index]["date"]);
      var forecastDate = DateFormat('EEE, d MMM').format(parsedDate);

      String weatherName = weatherData[index]["day"]["condition"]["text"];
      String weatherIcon = weatherData[index]["day"]["condition"]["text"].toString().replaceAll(' ', '').toLowerCase() + ".png";//replace(' ','').toLowerCase() + ".png";
      int minTemperature = widget.isCelsius ? weatherData[index]["day"]["mintemp_c"].toInt() : weatherData[index]["day"]["mintemp_f"].toInt();
      int maxTemperature = widget.isCelsius ? weatherData[index]["day"]["maxtemp_c"].toInt() : weatherData[index]["day"]["maxtemp_f"].toInt();

      var forecastData = {
        'maxWindSpeed' : maxWindSpeed,
        'avgHumidity' : avgHumidity,
        'chanceOfRain' : chanceOfRain,
        'forecastDate' : forecastDate,
        'weatherName' : weatherName,
        'weatherIcon' : weatherIcon,
        'minTemperature' : minTemperature,
        'maxTemperature' : maxTemperature
      };
      return forecastData;
    }

    //print(getForecastWeather(0));
    return Scaffold(
      //drawer: NavBar(onToggleTemperature: onToggleTemperature),
      backgroundColor: isDarkMode ? Color(0xff143079) : _constants.corePrimaryColor, //0xff071c8f,0xff051779
      appBar: AppBar(
        title: Text('Forecasts',style: TextStyle(
          fontSize: 24,
            color: Colors.white
        ),),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: isDarkMode ?  Color(0xff143079) : _constants.corePrimaryColor,
        // Color(0xff00133a)
        elevation: 0.0,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back),color: Colors.white,),
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
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
              top: 100, left: 0,
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    gradient: isDarkMode ? const LinearGradient(
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
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                        top: -50, right: 20, left: 20,
                        child: Container(
                            height: 300,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                              gradient: isDarkMode ? _constants.linearGradientBlue :
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(top: 10,left: 10,child: Image.asset("assets/images/dashboard/"+getForecastWeather(0)["weatherIcon"]),width: 150,),
                                Positioned(
                                    top: 160, left: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: Text(getForecastWeather(0)["weatherName"],
                                          style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                                    )
                                ),
                                Positioned(
                                    bottom: 15, left: 25,
                                    child: Container(
                                      width: size.width * 0.8,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          weatherItem(
                                              value: getForecastWeather(0)["maxWindSpeed"],
                                              unit: "km/h",
                                              weatherIcon: "assets/images/dashboard/windspeed.png"),
                                          weatherItem(
                                              value: getForecastWeather(0)["avgHumidity"],
                                              unit: "%",
                                              weatherIcon: "assets/images/dashboard/humidity.png"),
                                          weatherItem(
                                              value: getForecastWeather(0)["chanceOfRain"],
                                              unit: "%",
                                              weatherIcon: "assets/images/dashboard/lightrain.png"),
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    top: 20,right: 20,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(getForecastWeather(0)["maxTemperature"].toString(),
                                            style: TextStyle(
                                              fontSize: 90,
                                              fontWeight: FontWeight.bold,
                                              foreground: Paint()..shader = _constants.shader,
                                            )),
                                        Text('o',
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              foreground: Paint()..shader = _constants.shader,
                                            )),
                                      ],
                                    )),
                                // Positioned(
                                //     top: 330,
                                //     child: SizedBox(
                                //       height: 200,
                                //       width: size.width*0.9,
                                //       child: ListView.builder(
                                //           scrollDirection: Axis.vertical,
                                //           itemCount: widget.dailyForecastWeather.length,
                                //           itemBuilder: (BuildContext context, int index){
                                //             return Container(
                                //               margin: const EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 5),
                                //               height: 80,
                                //               width: size.width,
                                //               decoration: BoxDecoration(
                                //                 color: Colors.white,
                                //                 borderRadius: BorderRadius.all(Radius.circular(10)),
                                //                 boxShadow: [
                                //                   BoxShadow(
                                //                     color: _constants.coreSecondaryColor.withOpacity(0.1),
                                //                     spreadRadius: 5,
                                //                     blurRadius: 20,
                                //                     offset: const Offset(0, 3)
                                //                   )
                                //                 ]
                                //               ),
                                //               child: Padding(
                                //                 padding: const EdgeInsets.all(8.0),
                                //                 child: Row(
                                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                   crossAxisAlignment: CrossAxisAlignment.center,
                                //                   children: [
                                //                     Text(getForecastWeather(index)["forecastDate"],style: TextStyle(
                                //                       color: Color(0xff6696f5),
                                //                     ),),
                                //                     Row(
                                //                       children: [
                                //                         Text(getForecastWeather(index)["maxTemperature"].toString(),
                                //                           style: TextStyle(color: Colors.grey, fontSize: 25,fontWeight: FontWeight.w600),),
                                //                         Text('/',
                                //                           style: TextStyle(color: Colors.grey, fontSize: 25,fontWeight: FontWeight.w600),),
                                //                         Text(getForecastWeather(index)["minTemperature"].toString(),
                                //                           style: TextStyle(color: Colors.grey, fontSize: 25,fontWeight: FontWeight.w600),),
                                //                       ],
                                //                     ),
                                //                     Column(
                                //                       mainAxisAlignment: MainAxisAlignment.center,
                                //                       children: [
                                //                         Image.asset('assets/images/dashboard/'+getForecastWeather(index)["weatherIcon"],width: 30,),
                                //                         Text(getForecastWeather(index)["weatherName"]),
                                //                       ],
                                //                     )
                                //                   ],
                                //                 ),
                                //               ),
                                //             );
                                //     },
                                //     )))
                                Positioned(
                                    top: 330,
                                    child: SizedBox(
                                      height: 400,
                                      width: size.width * 0.9,
                                      child: ListView(
                                        scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(),
                                        children: [
                                          Card(
                                            color: isDarkMode ? Color(
                                                0xff6696f5) : Colors.white,
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
                                                      Text(getForecastWeather(0)["forecastDate"],style: TextStyle(
                                                        color: isDarkMode ? Colors.white : Color(0xff6696f5),
                                                        fontWeight: FontWeight.w600,fontSize: 18
                                                      )),
                                                      Row(
                                                        children: [
                                                          Row(
                                                              children: [
                                                                Text(getForecastWeather(0)["minTemperature"].toString(),
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
                                                            Text(getForecastWeather(0)["maxTemperature"].toString(),
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
                                                          Image.asset("assets/images/dashboard/"+getForecastWeather(0)["weatherIcon"],width: 30,),
                                                          const SizedBox(width: 5,),
                                                          Text(getForecastWeather(0)["weatherName"],
                                                            style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.grey.shade100 :Colors.grey),)
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(getForecastWeather(0)["chanceOfRain"].toString() + "%",
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
