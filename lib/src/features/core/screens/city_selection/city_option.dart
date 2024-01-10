import 'package:flutter/material.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/features/core/screens/city_selection/city.dart';
import 'package:get/get.dart';
import 'package:mausam/src/features/core/screens/dashboard/home.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';

class CityOption extends StatefulWidget {
  const CityOption({Key? key}) : super(key: key);

  @override
  State<CityOption> createState() => _CityOptionState();
}

class _CityOptionState extends State<CityOption> {
  @override
  Widget build(BuildContext context) {
    List<City> cities = City.citiesList.where((city) => city.isDefault == false).toList();
    List<City> selectedCities = City.getSelectedCities();

    //Constants myConstants = Constants();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: coreColor2,
        title: Text(selectedCities.length.toString() + ' selected'),
      ),
      body: ListView.builder(
        //physics: const BouncingScrollPhysics(),
        itemCount: cities.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: size.height * .08,
            width: size.width,
            decoration: BoxDecoration(
                border: cities[index].isSelected == true ? Border.all(
                  color: coreColor2.withOpacity(.6),
                  width: 2,
                ) : Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: coreColor1.withOpacity(.2),
                    spreadRadius: 5,
                    blurRadius: 7,
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
                      });
                    },
                    child: Image.asset(cities[index].isSelected == true ? checked : unchecked, width: 30,)),
                const SizedBox( width: 10,),
                Text(cities[index].city, style: TextStyle(
                  fontSize: 16,
                  color: cities[index].isSelected == true ? coreColor1 : Colors.black54,
                ),)
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: coreColor2,
        child: const Icon(Icons.pin_drop),
        onPressed: (){
          Get.off(() => const HomePage());
        },
      ),
    );
  }
}