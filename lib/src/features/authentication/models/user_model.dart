import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

// UserModel class for representing user data
class UserModel {
  final String? id;       // Unique identifier for the user
  final String name;      // Name of the user
  final String email;     // Email address of the user
  final String password;  // Encrypted password of the user

  // Constructor for UserModel
  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
  });

  // Convert UserModel to JSON format
  toJson() {
    return {
      "id": id,
      "Name": name,
      "Email": email,
      "Password": password,
    };
  }

  // Factory method to create UserModel from Firestore document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      password: data["Password"],
      name: data["Name"],
    );
  }

  // Method to decrypt and return the user's password
  String getDecryptedPassword() {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));
    final encryptedPassword = encrypt.Encrypted.fromBase64(password);
    return encrypter.decrypt(encryptedPassword, iv: encrypt.IV.fromLength(16));
  }
}

// CityModel class for representing city data
class CityModel {
  final String? cities;  // Name of the city

  // Constructor for CityModel
  const CityModel({
    this.cities,
  });

  // Convert CityModel to JSON format
  toJson() {
    return {
      "City": cities,
    };
  }

  // Factory method to create CityModel from Firestore document snapshot
  factory CityModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CityModel(
      cities: data["City"],
    );
  }
}
