import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_app/models/devices.dart';
import 'package:iot_app/models/system_log.dart';
import 'package:iot_app/models/users.dart';

class DataFirebase {
  // get data user
  static Future<Users> getUserRealTime(Users u) async {
    try {
      // Fetch data from Realtime Database
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(u.userID);
      DataSnapshot snapshot = await userRef.get();
      Map<dynamic, dynamic>? userData =
          snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        // Create Users object from the retrieved data
        Map<String, dynamic> systems = userData['systems'] != null
            ? Map<String, dynamic>.from(userData['systems'])
            : {};

        Users user = Users.realTimeCloud(
          username: userData['user_name'],
          address: userData['address'],
          email: u.email,
          userID: u.userID,
          image: userData['image'],
          systems: systems,
        );
        return user;
      }
      throw e;
    } catch (e) {
      throw e;
    }
  }

  // get name of a system
  static Future<String> getNameOfSystem(String idSystem) async {
    try {
      DatabaseReference systemRef = FirebaseDatabase.instance
          .ref()
          .child('Systems')
          .child(idSystem)
          .child("name");
      DataSnapshot snapshot = await systemRef.get();
      if (snapshot.exists) {
        return snapshot.value as String;
      } else {
        return "";
      }
    } catch (e) {
      print("Error getting system name: ${e.toString()}");
      return "";
    }
  }

  // add a system
  static Future<bool> addSystem(String idSystem, String key, Users u) async {
    try {
      DatabaseReference systemRef = FirebaseDatabase.instance
          .ref()
          .child('Systems')
          .child(idSystem)
          .child("Key");
      DataSnapshot snapshot = await systemRef.get();
      // if no exception throw, idSystem exist
      if (snapshot.exists) {
        DatabaseReference r = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(u.userID)
            .child("systems")
            .child(idSystem);
        print(snapshot.value);
        if (key.trim() != null && snapshot.value == key) {
          // is admin
          await r.update({"admin": 1});
        } else {
          // is not admin
          await r.update({"admin": 0});
        }
      }

      return true;
    } catch (e) {
      // idSystem not exist
      print("Error getting system name: ${e.toString()}");
      return false;
    }
  }

  // update name for a system
  static Future<bool> setNameOfSystem(String idSystem, String data) async {
    try {
      DatabaseReference systemRef =
          FirebaseDatabase.instance.ref().child('Systems').child(idSystem);
      await systemRef.update({"name": data});
      return true;
    } catch (e) {
      print("Error setting system name: ${e.toString()}");
      return false;
    }
  }

// get all devices in a system
  static Future<List<Device>> getAllDevices(String idSystem) async {
    try {
      List<Device> deviceList = [];
      DatabaseReference devicesRef = FirebaseDatabase.instance
          .ref()
          .child('Systems')
          .child(idSystem)
          .child("devices");

      DataSnapshot snapshot = await devicesRef.get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> devicesMap =
            snapshot.value as Map<dynamic, dynamic>;
        devicesMap.forEach((key, value) {
          deviceList.add(Device.fromJson(
              idSystem, key, Map<String, dynamic>.from(value as Map)));
        });
      }
      return deviceList;
    } catch (e) {
      print("Error getting devices: ${e.toString()}");
      throw e;
    }
  }

  // get list log of a system
  static Future<List<SystemLog>> getListLog(String systemID) async {
    try {
      List<SystemLog> logs = [];
      DatabaseReference logsRef = FirebaseDatabase.instance
          .ref()
          .child('Systems')
          .child(systemID)
          .child("log");

      DataSnapshot snapshot = await logsRef.get();
      if (snapshot.exists) {
        (snapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
          logs.add(SystemLog.fromJson(key, value));
        });
      }
      return logs;
    } catch (e) {
      print("Error getting system logs: ${e.toString()}");
      throw e;
    }
  }

  // stream device
  static Stream<Device> getStreamDevice(Device d) {
    StreamController<Device> controller = StreamController<Device>();
    try {
      DatabaseReference deviceRef = FirebaseDatabase.instance
          .ref()
          .child('Systems')
          .child(d.systemID)
          .child("devices")
          .child(d.id);
      deviceRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          controller.add(Device.fromJson(
              d.systemID, d.id, event.snapshot.value as Map<Object?, Object?>));
        }
      });
    } catch (e) {
      print("Error streaming device: ${e.toString()}");
      controller.addError(e);
    }
    return controller.stream;
  }

  // stream logs
  static Stream<List<SystemLog>> getStreamLogs(String idSystem) {
    StreamController<List<SystemLog>> controller =
        StreamController<List<SystemLog>>();

    DatabaseReference deviceRef = FirebaseDatabase.instance
        .ref()
        .child('Systems')
        .child(idSystem)
        .child("log");

    StreamSubscription? subscription;

    subscription = deviceRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        final List<SystemLog> logs = data.entries
            .map((entry) => SystemLog.fromJson(entry.key, entry.value))
            .toList();
        controller.add(logs);
      }
    }, onError: (error) {
      controller.addError(error);
    });

    controller.onCancel = () {
      subscription?.cancel();
    };

    return controller.stream;
  }

  // update name of device
  static Future<bool> setNameOfDevice(Device device, String data) async {
    try {
      DatabaseReference deviceRef = FirebaseDatabase.instance
          .ref()
          .child('Systems')
          .child(device.systemID)
          .child("devices")
          .child(device.id);
      await deviceRef.update({"name": data});
      return true;
    } catch (e) {
      print("Error setting device name: ${e.toString()}");
      return false;
    }
  }
}
