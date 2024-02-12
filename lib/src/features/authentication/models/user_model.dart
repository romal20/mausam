import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel
{
  final String? id;
  final String name;
  final String email;
  //final String phoneNo;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    //required this.phoneNo,
  });

  toJson(){
    return{
      "Name":name,
      //"Phone":phoneNo,
      "Email":email,
      "Password":password,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>>document){
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data["Email"],
        password: data["Password"],
        name: data["Name"]);
        //phoneNo: data["Phone"]);
  }
}

class CityModel
{
  final String? cities;

  const CityModel({
    this.cities,
  });

  toJson(){
    return{
      "City":cities,
    };
  }

  factory CityModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>>document){
    final data = document.data()!;
    return CityModel(
        cities: data["City"]);
  }
}