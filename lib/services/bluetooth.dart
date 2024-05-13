import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:iot_app/widgets/Notice/notice_snackbar.dart';

class BluetoothService {
  Future<bool> turnOnBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      // const CustomSnackBar(
      //     message: "Bluetooth not supported by this device ", seconds: 3);
      return false;
    }
    bool ok = false;

    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // start scanning, connecting
        ok = true;
      } else {
        // const CustomSnackBar(message: "Cannot turn on bluetooth", seconds: 3);
      }
    });
    // turn on bluetooth ourself if we can
// for iOS, the user controls bluetooth enable/disable
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

// cancel to prevent duplicate listeners
    subscription.cancel();
    return ok;
  }

  Future<bool> turnOffBluetooth() async {
    try {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
      await FlutterBluePlus.turnOn().timeout(Duration.zero); // Tắt Bluetooth
      return true;
    } catch (e) {
      print('Error turning off Bluetooth: $e');
      return false;
    }
  }

  Future<bool> scanBluetooth() async {
    try {
      // start scanning
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      // listen to scan results
      await for (List<ScanResult> results in FlutterBluePlus.scanResults) {
        // Loop through each scan result in the list
        for (ScanResult result in results) {
          // Process each scan result here
          print('Found device: ${result.device.advName}');
          // You can add the scan result to your list if needed
          // scanResults.add(result);
        }
      }
      // Stop scanning after the loop ends
      FlutterBluePlus.stopScan();

      // Return true indicating successful scan
      return true;
    } catch (e) {
      // Handle any errors that occur during scanning
      print(e);
      return false;
    }
  }

  Future<bool> connectToBluetoothDevice(BluetoothDevice device) async {
    try {
      // Connect to the selected Bluetooth device
      await device.connect();
      // If connection is successful, return true
      return true;
    } catch (e) {
      // Handle any errors that occur during connection
      print('Error connecting to Bluetooth device: $e');
      return false;
    }
  }
}
