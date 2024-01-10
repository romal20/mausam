class Weather{
  final double tempC;
  final double tempF;
  final String condition;

  Weather({
    this.tempC = 0,
    this.tempF = 0,
    this.condition = "Sunny",
  });

  factory Weather.fromJson(Map<String,dynamic> json){
    return Weather(
      tempC: json['current']['temp_c'],
      tempF: json['current']['temp_f'],
      condition: json['current']['condition']['text'],
    );
  }
}