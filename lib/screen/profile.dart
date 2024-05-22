import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/screen/profile_setting.dart';
import 'package:iot_app/screen/wellcome.dart';
import 'package:iot_app/provider/data_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _profileScreenState createState() => _profileScreenState();
}

// ignore: camel_case_types
class _profileScreenState extends State<ProfileScreen> {
  late Users user;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    FetchUserData1();
  }

  Future<void> FetchUserData1() async {
    try {
      user = await FetchUserData.getDataUser();
      setState(() {
        isDataLoaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 248, 250, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 248, 250, 1),
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 90,
                backgroundColor: Colors.grey[300], // Màu nền cho hình tròn
                child: ClipOval(
                  child: AspectRatio(
                    aspectRatio: 1, // Đảm bảo tỷ lệ khung hình là 1:1
                    child: Image.file(
                      File(user.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                user.username,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                user.email,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                user.address,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSetting()));
                },
                child: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _logout();
                },
                child: const Text("   Log Out   "),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    FetchUserData.clearDataUser();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WellcomeScreen()));
  }
}
