import 'dart:convert';

import 'package:iot_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static Future<String?> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<Users> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');
    String? userName = prefs.getString('userName');
    String? email = prefs.getString('email');
    String? address = prefs.getString('address');
    String? image = prefs.getString('image'); 

    if (userId != null &&
        userName != null &&
        email != null &&
        address != null &&
        image != null) {
     
      return Users.sharedPreferences(
        userID: userId,
        username: userName,
        email: email,
        address: address,
        image: image,      
      );
    } else {
      throw Exception("Failed to fetch user data from SharedPreferences");
    }
  }

  static Future<bool> setDataUser(Users user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userID', user.userID);
      await prefs.setString('userName', user.username);
      await prefs.setString('email', user.email);
      await prefs.setString('address', user.address);
      await prefs.setString('image', user.image);     
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> clearDataUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userID', "");
      await prefs.setString('userName', "");
      await prefs.setString('email', "");
      await prefs.setString('address', "");
      await prefs.setString('image', "");   
      clearData();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
