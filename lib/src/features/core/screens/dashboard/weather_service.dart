import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mausam/src/features/core/screens/dashboard/weather.dart';

class WeatherService {
  Future<Weather> getWeatherData(String place) async {
    try{
      final queryParameters = {
        'key':'dfccf20139b94abd8df162403240501',
        'q':place,
      };
      final uri = Uri.http('api.weather.com','/v1/current.json',queryParameters);
      final response = await http.get(uri);
      if(response.statusCode == 200){
        return Weather.fromJson(jsonDecode(response.body));
      }else{
        throw Exception("Cannot get weather");
      }
    }catch(e){
      rethrow;
    }
  }
}