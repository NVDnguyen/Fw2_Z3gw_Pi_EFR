import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/provider/data_user.dart';
import 'package:iot_app/services/realtime_firebase.dart';
import 'package:path/path.dart';

class MySystemScreen extends StatefulWidget {
  const MySystemScreen({super.key});

  @override
  State<MySystemScreen> createState() => _MySystemScreenState();
}

class _MySystemScreenState extends State<MySystemScreen> {
  late Users user;
  bool isDataLoaded = false;
  String data = "";
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
      // list id system
      data = user.getSystems().toString();

      setState(() {
        isDataLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: Text(data,style: TextStyle(fontSize: 18),),
      ),
    );
  }
}
