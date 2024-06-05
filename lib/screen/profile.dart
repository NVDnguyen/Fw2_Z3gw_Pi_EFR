import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/screen/profile_setting.dart';
import 'package:iot_app/screen/wellcome.dart';
import 'package:iot_app/provider/data_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Users user;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      Users u = await SharedPreferencesProvider.getDataUser();
      user = u;
      // user = await DataFirebase.getUserRealTime(u);
      // SharedPreferencesProvider.setDataUser(user);
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
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isDataLoaded
          ? SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(user.image)),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      SizedBox(height: 16),
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "@${user.username.toLowerCase().replaceAll(' ', '_')}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileSetting(),
                            ),
                          );
                        },
                        child: Text("Edit Profile"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 227, 230, 235),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildProfileOption(
                        icon: Icons.settings,
                        text: "Settings",
                        onTap: () {},
                      ),
                      Divider(),
                      _buildProfileOption(
                        icon: Icons.device_hub_outlined,
                        text: "My Systems",
                        onTap: () {},
                      ),
                      Divider(),
                      _buildProfileOption(
                        icon: Icons.group,
                        text: "Group ",
                        onTap: () {},
                      ),
                      Divider(),
                      _buildProfileOption(
                        icon: Icons.attach_money_sharp,
                        text: "Donate",
                        onTap: () {},
                      ),
                      Divider(),
                      _buildProfileOption(
                        icon: Icons.share,
                        text: "Share",
                        onTap: () {},
                      ),
                      Divider(),
                      _buildProfileOption(
                        icon: Icons.logout,
                        text: "Log out",
                        onTap: () {
                          _logout();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _logout() {
    SharedPreferencesProvider.clearDataUser();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WellcomeScreen()),
    );
  }
}
