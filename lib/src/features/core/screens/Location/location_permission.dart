import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';

class GetLocationPermission extends StatefulWidget {
  const GetLocationPermission({Key? key}) : super(key: key);

  @override
  State<GetLocationPermission> createState() => _GetLocationPermissionState();
}

class _GetLocationPermissionState extends State<GetLocationPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 70,),
            Text("Location Permission",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
            SizedBox(height: 60,),
            Text("Turn on location service to get the most",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
            Text("accurate forecast for your location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
            SizedBox(height: 20,),
            Image.asset("assets/images/weather-app.png",height: 100,width: 100,),
            SizedBox(height: 20),
            Text("We use your location to provide local weather.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
            Text("You can change it anytime in your setting.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              getLoc();
              Get.to(() => HomePage());
            }, child: Text("ENABLE LOCATION"))
          ],
        ),
      ),
    );
  }
}

  Future<Position> getLoc() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }


    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    print(position);

    return await Geolocator.getCurrentPosition();
  }