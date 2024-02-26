import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/core_constants.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/core/screens/Location/location_permission.dart';
import 'package:mausam/src/features/core/screens/city_selection/city.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';

class CityOption extends StatefulWidget {
  const CityOption({Key? key}) : super(key: key);

  @override
  State<CityOption> createState() => _CityOptionState();
}

class _CityOptionState extends State<CityOption> {
  late List<City> cities;
  late List<City> selectedCities;
  var latitude;
  var longitude;
  @override

  void initState() {
    super.initState();
    _loadCities();
    //_loadSelectedCities();
  }

  Future<void> _loadCities() async {
    setState(() {
      cities = City.citiesList.where((city) => city.isDefault == false).toList();
    });
  }

  /*Future<void> _loadSelectedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? selectedCityNames = prefs.getStringList('selectedCities');
    if (selectedCityNames != null) {
      setState(() {
        selectedCities = cities.where((city) => selectedCityNames.contains(city.city)).toList();
      });
    } else {
      setState(() {
        selectedCities = [];
      });
    }
  }*/

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      print("Permission not given");
      Geolocator.requestPermission();
    }
    else{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,forceAndroidLocationManager: true);
      print(position);
    }


  }

  Widget build(BuildContext context) {

     List<City> cities = City.citiesList.where((city) => city.isDefault == false).toList();
     List<City> selectedCities = City.getSelectedCities();

        //Constants myConstants = Constants();
    Size size = MediaQuery.of(context).size;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Constants _constants = Constants();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? Colors.black87 : coreColor2, //isDarkMode ? Color(0xff09013f) :
        title: Text(selectedCities.length.toString() + ' selected'),
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: cities.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: size.height * .08,
              width: size.width,//0xFF280965
              decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : coreColor1.withOpacity(0.2),
                  border: cities[index].isSelected == true ? Border.all(
                    color: isDarkMode ? coreColor2 : coreColor2.withOpacity(.6),
                    width: 2,
                  ) : Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.white.withOpacity(.2) :coreColor1.withOpacity(.2),
                      spreadRadius: 4,  //5
                      blurRadius: 6,   //7
                      offset: const Offset(0, 3),
                    )
              ]
              ),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          cities[index].isSelected =! cities[index].isSelected;
                          //Text(cities[index].city, style: TextStyle(color: cities[index].isSelected == true ? coreColor1 : Colors.black54));

                        });
                      },
                      child: Image.network(cities[index].isSelected == true ? checked : unchecked, width: 30,)),
                  const SizedBox( width: 10,),
                  Text(cities[index].city, style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black
                    //color: cities[index].isSelected == true ? coreColor1 : Colors.black54,
                  ))
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode? Colors.white : coreColor2,
        child: Icon(Icons.pin_drop, color: isDarkMode ? Colors.black : Colors.white),
        onPressed: (){
          getLocation();
          Get.offAll(() => const HomePage());
          //Get.offAll(() => const GetLocationPermission());
        },
      ),
    );
  }
}