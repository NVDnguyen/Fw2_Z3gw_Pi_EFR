import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/models/system_log.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/provider/data_user.dart';
import 'package:iot_app/services/realtime_firebase.dart';
import 'package:iot_app/widgets/Dashboard/news_stream.dart';

class NewsScreen extends StatefulWidget {
  @override
  _newScreenState createState() => _newScreenState();
}

class _newScreenState extends State<NewsScreen> {
  late Users user;
  bool isDataLoaded = false;
  List<SystemLog> systemLogs = [];
  List<Widget> wLogs = [];

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
      List<String> lSystem = user.getSystemIDs();
      for (var e in lSystem) {
        String nameST = await DataFirebase.getNameOfSystem(e);
        wLogs.add(
          buildInfoLogs(idSystem: e, nameSystems: nameST),
        );
      }

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
    // TODO: implement build
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 248, 250, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Text("News"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [...wLogs],
                ),
              ),
            ],
          ),
        ));
  }
}
