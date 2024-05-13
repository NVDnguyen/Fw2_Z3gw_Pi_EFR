import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_app/services/realtime_firebase.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class IoTGauge extends StatefulWidget {
  final String virtualPin;
  final String name;
  final String meter;
  final double max;
  final double min;
  final Color color;

  const IoTGauge({
    Key? key,
    required this.virtualPin,
    required this.name,
    required this.max,
    required this.min,
    required this.meter,
    required this.color,
  }) : super(key: key);

  @override
  _IoTGaugeState createState() => _IoTGaugeState();
}

class _IoTGaugeState extends State<IoTGauge> {
  late double _value;
  late Stream<String> _gauge;
  String dataDisplay = "";

  @override
  void initState() {
    super.initState();
    _value = 0.0;
    _startListeningToFirebase();
    dataDisplay = _value.toString() + widget.meter;
  }

  // Phương thức để lắng nghe dữ liệu từ Firebase
  Future<void> _startListeningToFirebase() async {
    // Simulate fetching data from Firebase
    await Future.delayed(Duration(seconds: 2));
    DataFirebase().getStream(widget.virtualPin).then((value) {
      _gauge = value;
      _gauge.listen((value) {
        setState(() {
          _value = double.parse(value);
          dataDisplay = _value.toString() + widget.meter;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedRadialGauge(
          duration: const Duration(seconds: 1),
          value: _value,
          radius: 100,
          axis: GaugeAxis(
            min: widget.min,
            max: widget.max,
            degrees: 180,
            style: const GaugeAxisStyle(
              thickness: 20,
              background: Color(0xFFDFE2EC),
              segmentSpacing: 4,
            ),
            pointer: const GaugePointer.needle(
              width: 10,
              height: 50,
              color: Color.fromARGB(255, 36, 86, 160),
            ),
            progressBar: GaugeProgressBar.rounded(
              color: widget.color,
            ),
          ),
        ),
        SizedBox(
          height: 20,
          child: Text(
            dataDisplay,
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 20,
          child: Text(
            widget.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
