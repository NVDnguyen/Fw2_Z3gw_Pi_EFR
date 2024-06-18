import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/screen/my_system.dart';
import 'package:iot_app/screen/profile_setting.dart';
import 'package:iot_app/screen/wellcome.dart';
import 'package:iot_app/provider/data_user.dart';
import 'package:iot_app/services/realtime_firebase.dart';

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
      user = await SharedPreferencesProvider.getDataUser();
      Users u = await DataFirebase.getUserRealTime(user);

      setState(() {
        isDataLoaded = true;
        if (u != user) {
          SharedPreferencesProvider.setDataUser(u);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 248, 250, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(247, 248, 250, 1),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isDataLoaded
          ? SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(user.image)),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "@${user.username.toLowerCase().replaceAll(' ', '_')}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildProfileOption(
                        icon: Icons.settings,
                        text: "Settings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileSetting(),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      _buildProfileOption(
                        icon: Icons.device_hub_outlined,
                        text: "My Systems",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MySystemScreen(),
                              ));
                        },
                      ),
                      const Divider(),
                      _buildProfileOption(
                        icon: Icons.group,
                        text: "Group ",
                        onTap: () {},
                      ),
                      const Divider(),
                      _buildProfileOption(
                        icon: Icons.attach_money_sharp,
                        text: "Donate",
                        onTap: () {},
                      ),
                      const Divider(),
                      _buildProfileOption(
                        icon: Icons.share,
                        text: "Share",
                        onTap: () {},
                      ),
                      const Divider(),
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
          : const Center(
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
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
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
