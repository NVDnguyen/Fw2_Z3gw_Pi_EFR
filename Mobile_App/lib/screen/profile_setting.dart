import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/screen/profile.dart';
import 'package:iot_app/services/auth_firebase.dart';
import 'package:iot_app/provider/data_user.dart';
import 'package:iot_app/provider/image_picker.dart';
import 'package:iot_app/widgets/Notice/notice_snackbar.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  late Users user;
  late String _image;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    FetchUserData1();
  }

  Future<void> FetchUserData1() async {
    try {
      user = await SharedPreferencesProvider.getDataUser();
      _image = user.image;
      // Gán giá trị cũ vào các TextEditingController
      _usernameController.text = user.username;
      _addressController.text = user.address;
      setState(() {
        isDataLoaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 248, 250, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 248, 250, 1),
        title: Text('Edit Profile'),
        // Nút "Back" trên App bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _image.isNotEmpty ? FileImage(File(_image)) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _imagePicker();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'User Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _usernameController,
              ),
              const SizedBox(height: 20),
              const Text(
                'Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _addressController,
              ),
              const SizedBox(height: 20),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                // ElevatedButton(
                //   onPressed: () {
                //   Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => Layout(),
                //             ),
                //           );
                //   },
                //   child: const Text('Back'),
                // ),
                // const SizedBox(
                //   width: 30,
                // ),
                ElevatedButton(
                  onPressed: () {
                    _save(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    // Viết mã để lưu thông tin mới
    String? _username = _usernameController.text;
    String? _address = _addressController.text;
    Users us = user.updateUser(_username, _address, _image);
    print(us.username + us.address);
    AuthService _auth = AuthService();
    if (await _auth.updateUserInfo(us)) {
      if (await SharedPreferencesProvider.setDataUser(us)) {
        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      } else {
        print("FetchUserData.setDataUser fail");
      }
    } else {
      showSnackBar(context, "Update user fail");
    }
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _usernameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _imagePicker() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
    }
  }
}
