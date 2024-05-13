import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_app/services/realtime_firebase.dart';

class IoTSwitch extends StatefulWidget {
  final String virtualPin;
  final String nameSwitch;
  final Color colorSwitch;

  const IoTSwitch({
    Key? key,
    required this.virtualPin,
    required this.nameSwitch,
    required this.colorSwitch,
  }) : super(key: key);

  @override
  _IoTSwitchState createState() => _IoTSwitchState();
}

class _IoTSwitchState extends State<IoTSwitch> {
  bool _isSwitched = false;
  late Stream<String> _switchStream;
  @override
  void initState() {
    super.initState();
    fetchRealtimeFirebase();
  }

  Future<void> fetchRealtimeFirebase() async {
    DataFirebase().getStream(widget.virtualPin).then((value) {
      _switchStream = value;
      _switchStream.listen((value) {
        setState(() {
          _isSwitched = value == "1";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          // Execute your action here
          print("Long pressed!");
          HapticFeedback.vibrate(); //  haptic feedback
        },
        child: Container(
          constraints: const BoxConstraints(minWidth: 130, minHeight: 60),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.nameSwitch,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Switch(
                value: _isSwitched,
                onChanged: (value) {
                  _switchAction(value);
                },
                activeTrackColor: Colors.grey,
                activeColor: widget.colorSwitch,
              ),
            ],
          ),
        ));
  }

  void _switchAction(bool value) async {
    try {
      int valueInt = value ? 1 : 0;
      String valueStr = valueInt.toString();
      await DataFirebase().setData(widget.virtualPin, valueStr);
      fetchRealtimeFirebase();
    } catch (e) {
      print("Error setting data to Firebase: $e");
    }
  }
}
