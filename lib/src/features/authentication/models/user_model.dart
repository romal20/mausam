import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
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
      "id":id,
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

  String getDecryptedPassword() {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));
    final encryptedPassword = encrypt.Encrypted.fromBase64(password);
    return encrypter.decrypt(encryptedPassword, iv: encrypt.IV.fromLength(16));
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