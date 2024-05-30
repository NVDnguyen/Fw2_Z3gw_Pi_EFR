// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/models/devices.dart';
import 'package:iot_app/services/realtime_firebase.dart';
import 'package:iot_app/widgets/Dashboard/dashboard_widgets.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/provider/data_user.dart';
import 'package:iot_app/widgets/Notice/notice_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Users user;
  bool isDataLoaded = false;
  bool isSystemChossen = false;

  // Create List of SystemLog Objects

  List<Device> lDevice = [];
  List<Widget> wDashBoard = [];
  List<Widget> wDashBoard1 = [];
  List<Widget> wSystems = [];
  List<Widget> wDevices = [];
  String selectedDevice = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      //sys with cloud
      user = await SharedPreferencesProvider.getDataUser();
      Users userNew = await DataFirebase.getUserRealTime(user);

      if (userNew != user) {
        user = userNew;
        SharedPreferencesProvider.setDataUser(user);
      }
      // buid dash board
      await buildSystemList();
      setState(() {
        isDataLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> buildSystemList() async {
    try {
      Users userNew = await DataFirebase.getUserRealTime(user);
      if (userNew != user) {
        user = userNew;
        SharedPreferencesProvider.setDataUser(user);
      }
      List<String> listSystems = userNew.getSystemIDs();
      List<Widget> w = [];

      // parallel
      List<Future> futures = listSystems.map((e) async {
        var devicesFuture = DataFirebase.getAllDevices(e);
        var systemNameFuture = DataFirebase.getNameOfSystem(e);
        return Future.wait([devicesFuture, systemNameFuture, Future.value(e)]);
      }).toList();

      // wait for all done
      var results = await Future.wait(futures);

      // process results
      for (var result in results) {
        List<Device> dvc = result[0];
        String systemName = result[1];
        String e = result[2];

        w.add(
          BuildHomeWidgets.buildDeviceCard1(
            e == selectedDevice,
            systemName,
            //'https://i.imgur.com/jFoufpl.jpeg',
            'https://img.freepik.com/premium-photo/concept-home-devices-multiple-houses-conected-networked_1059430-54450.jpg',
            onTap: () {
              setState(() {
                fetchUserData();
                buildSystemList();
                selectedDevice = e;
                wDevices = [];
                for (var device in dvc) {
                  wDevices.add(
                    BuildHomeWidgets.buildInfoSensor1(device, onPress: () {
                      // change name
                      final TextEditingController newNameDevice =
                          TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 16),
                                TextField(
                                  controller: newNameDevice,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "New name",
                                    prefixIcon:
                                        Icon(Icons.devices_other_outlined),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  updateDeviceName(device, newNameDevice.text);
                                  setState(() {
                                    fetchUserData();
                                    buildSystemList();
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Next'),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  );
                  wDevices.add(const SizedBox(height: 20));
                }
              });
            },
          ),
        );
      }

      setState(() {
        w.isEmpty ? isSystemChossen = true : wSystems = w;

        wDashBoard = [
          BuildHomeWidgets.buildInfoCard(
              "Bạn chưa lắp đặt hệ thống thiết bị nào",
              "Hãy lắp đặt các thiết bị an toàn, để bảo vệ bản thân, gia đình và mọi người xung quanh.",
              "Hướng cài đặt và sử dụng thiết bị",
              onTap: () => _launchUrl(Uri.parse('https://shopee.vn/'))),
          const SizedBox(height: 20),
          BuildHomeWidgets.buildInfoCard(
            "Nhà/Công trình bạn theo dõi",
            "Bạn muốn theo dõi hoạt động an toàn của khu vực khác?",
            "Quét mã gia nhập ngay",
            onTap: () => _launchUrl(Uri.parse('https://shopee.vn/')),
          ),
        ];
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error building system list: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController systemIDcontroller = TextEditingController();
    final TextEditingController systemKeycontroller = TextEditingController();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "FireWise",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [],
      ),
      body: isDataLoaded
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...wSystems,
                          BuildHomeWidgets.buildDeviceCard(
                            "Add Systems",
                            Icons.add_circle_outline,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Add New System",
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Please enter the System ID *",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: systemIDcontroller,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'System ID',
                                            prefixIcon: Icon(Icons.device_hub),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Please enter the Admin key",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: systemKeycontroller,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Key',
                                            prefixIcon: Icon(Icons.key),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          addSystem(systemIDcontroller.text,
                                              systemKeycontroller.text);
                                          setState(() {
                                            fetchUserData();
                                            buildSystemList();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Add'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...(isSystemChossen ? wDashBoard : wDashBoard1),
                    ...wDevices,
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> addSystem(String idSystem, String key) async {
    try {
      if (await DataFirebase.addSystem(idSystem, key, user)) {
        showSnackBar(context, "Add System Successfully");
      } else {
        showSnackBar(context, "Add System Fail");
      }
    } catch (e) {
      showSnackBar(context, "Add System Fail");
    }
  }

  Future<void> updateDeviceName(Device device, String text) async {
    bool isAdmin = user.isAdmin(device.systemID);
    try {
      if (isAdmin) {
        bool status = await DataFirebase.setNameOfDevice(device, text);
        if (status) {
          showSnackBar(context, "Change Success");
        } else {
          showSnackBar(context, "Cannot change");
        }
      } else {
        showSnackBar(context, "Dont have permission");
      }
    } catch (e) {
      showSnackBar(context, "Cannot change");
    }
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
