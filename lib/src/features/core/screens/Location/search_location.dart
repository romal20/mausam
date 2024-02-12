import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'hide Response;
import 'package:mausam/src/features/core/screens/Location/search_info.dart';
import 'package:mausam/src/features/core/screens/dashboard/home_page.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({Key? key}) : super(key: key);

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<SearchInfo> items = [];

  void placeAutoComplete(String val) async{
    await addressSuggestion(val).then((value){
      setState(() {
        items = value;
      });
    });
  }

  Future<List<SearchInfo>> addressSuggestion(String address) async {
    Response response = await Dio().get('https://photon.komoot.io/api/',queryParameters: {"q": address,"limit": 5});

    final json = response.data;
    return(json['features'] as List).map((e) => SearchInfo.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    SearchInfo a = SearchInfo();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined), onPressed: () {Get.off(() => HomePage()); },),
        title: Text('Search Location'),
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextField(
              onChanged: (val){
                if(val!=''){
                  placeAutoComplete(val);
                }
                else{
                  items.clear();
                  setState(() {});
                }
              },
              decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 14),
                prefixIcon: Icon(Icons.place),
                border: OutlineInputBorder(),
                hintText: 'Search City'),
            ),
            SizedBox(height: 20,),
            /*...items.map((e) => ListTile(
              leading: const Icon(Icons.place),
                title: Text(e.features[0].properties!.name!)  //e.properties!.name!
            )).toList()*/
            ...items.map((e) {
              final title = e.features?.isNotEmpty == true && e.features![0].properties?.name != null
                  ? e.features![0].properties!.name!
                  : 'Unknown';
              return ListTile(
                leading: const Icon(Icons.place),
                title: Text(title),
              );
            }).toList()

          ],
        ),
      ),
    );
  }
}