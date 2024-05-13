import 'package:flutter/material.dart';
import 'package:iot_app/services/realtime_firebase.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class IoTGaugeMulti extends StatefulWidget {
  final String virtualPin;
  final String name;
  final String meter;
  final double max;
  final double min;

  const IoTGaugeMulti({
    Key? key,
    required this.virtualPin,
    required this.name,
    required this.max,
    required this.min,
    required this.meter,
  }) : super(key: key);

  @override
  _IoTGaugeMultiState createState() => _IoTGaugeMultiState();
}

class _IoTGaugeMultiState extends State<IoTGaugeMulti> {
  double _value = 0.0; // Initial value
  late Stream<String> _gauge;
  String data = "";

  @override
  void initState() {
    super.initState();
    _startListeningToFirebase();
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
          data =_value.toString()+ widget.meter;
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
              progressBar: GaugeProgressBar.basic(color: Colors.transparent),
              segments: const [
                GaugeSegment(
                  from: 0,
                  to: 20,
                  color: Color.fromARGB(255, 78, 155, 228),
                  cornerRadius: Radius.zero,
                ),
                GaugeSegment(
                  from: 20.3,
                  to: 29,
                  color: Color.fromARGB(255, 123, 231, 150),
                  cornerRadius: Radius.zero,
                ),
                GaugeSegment(
                  from: 29.3,
                  to: 40,
                  color: Color.fromARGB(255, 238, 128, 38),
                  cornerRadius: Radius.zero,
                ),
                GaugeSegment(
                  from: 40.3,
                  to: 100,
                  color: Color.fromARGB(255, 233, 17, 2),
                  cornerRadius: Radius.zero,
                ),
              ]),
        ),
        SizedBox(
          height: 20,
          child: Text(
            data,
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
