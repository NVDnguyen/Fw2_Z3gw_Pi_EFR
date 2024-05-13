import 'package:flutter/material.dart';
import 'package:iot_app/models/widgets.dart';

List<Widget> toListWidget(List<Widgets> listWidget) {
  List<Widget> listWidgets = [];
  listWidget.forEach((element) {
    listWidgets.add(element.toWidget());
  });
  return listWidgets;
}

