import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/models/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchWidgetData {
  static Future<String?> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static void saveWidgets(List<Widgets> widgets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = widgets.map((w) => w.toJson()).toList();
    await prefs.setString('widgets', jsonEncode(jsonList));
  }

  static Future<void> addWidget(Widgets newWidget) async {
    final widgetsList = await loadWidgets();
    widgetsList.add(newWidget);
    saveWidgets(widgetsList);
  }

  static Future<List<Widgets>> loadWidgets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('widgets');
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((w) => Widgets.fromJson(w)).toList();
    }
    return [];
  }
}
