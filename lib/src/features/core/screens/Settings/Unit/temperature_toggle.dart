import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemperatureToggle extends StatefulWidget {
  @override
  _TemperatureToggleState createState() => _TemperatureToggleState();
}

class _TemperatureToggleState extends State<TemperatureToggle> {
  double val = 0;
  int groupValue = 0;
//  bool ftc = false;
//  bool ctf = false;
  String finalAnswer = "";

  handleTemperature(int value) {
    setState(() {
      if (value == 1) {
        //fahrenheit to celsius
        groupValue = 1;
//        ctf = false;
//        ftc = true;
        var ans = (val - 32.0) / 1.8;
        finalAnswer = ans.toString() + " C";
      } else if (value == 2) {
        //celsius to fahrenheit
        groupValue = 2;
//        ctf = true;
//        ftc = false;
        var ans = (val * 1.8) + 32;
        finalAnswer = ans.toString() + " F";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Enter value'),
            onChanged: (String value) {
              if (value.isEmpty) {
                Get.snackbar('','Please Enter Something');
                finalAnswer = '';
                return;
              } else {
                val = double.parse(value);
              }
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Radio(
                  activeColor: Colors.red,
                  value: 1,
                  groupValue: groupValue,
                  onChanged: (e) => handleTemperature(e!)),
              Text("Fahrenheit To Celsius"),
              SizedBox(
                height: 5.0,
              ),
              Radio(
                  activeColor: Colors.red,
                  value: 2,
                  groupValue: groupValue,
                  onChanged: (e) => handleTemperature(e!)),
              Text("Celsius To Fahrenheit"),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: Text('Clear'),
            onPressed: () {
              setState(() {
                finalAnswer== null;
              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(finalAnswer == null ? '' : finalAnswer)
        ],
      ),
    );
  }
}