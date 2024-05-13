import 'package:flutter/material.dart';
import 'package:iot_app/utils/color_utils.dart';
import 'package:iot_app/widgets/IoT/gauge.dart';
import 'package:iot_app/widgets/IoT/gauge_mult.dart';
import 'package:iot_app/widgets/IoT/switch.dart';

class Widgets {
  final String id;
  final String type;
  final String name;
  final String meter;
  final double max;
  final double min;
  final String color;

  Widgets(
      {required this.id,
      required this.type,
      required this.name,
      required this.meter,
      required this.max,
      required this.min,
      required this.color});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'meter': meter,
      'max': max,
      'min': min,
      'color': color
    };
  }

  factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
        id: json['id'],
        type: json['type'],
        name: json['name'],
        meter: json['meter'],
        max: json['max'],
        min: json['min'],
        color: json['color'],
      );

  Widget toWidget() {
    switch (type) {
      case 'Switch':
        {
          return Padding(
            padding: EdgeInsets.all(10),
            child: IoTSwitch(
              virtualPin: id,
              nameSwitch: name,
              colorSwitch: stringToColor(color),
            ),
          );
        }

      case 'Gauge_Mult':
        {
          return IoTGaugeMulti(
            virtualPin: id,
            name: name,
            max: max,
            min: min,
            meter: meter,
          );
        }
      case 'Gauge':
        {
          return IoTGauge(
            virtualPin: id,
            name: name,
            max: max,
            min: min,
            meter: meter,
            color: stringToColor(color),
          );
        }
    }
    return const SizedBox(
      child: Text(
        "Error",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
