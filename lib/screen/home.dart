import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:iot_app/constants/properties.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/models/widgets.dart';
import 'package:iot_app/provider/data_user.dart';
import 'package:iot_app/provider/data_widget.dart';
import 'package:iot_app/provider/user_provider.dart';
import 'package:iot_app/services/realtime_firebase.dart';
import 'package:iot_app/utils/color_utils.dart';
import 'package:iot_app/utils/widgets_utils.dart';
import 'package:iot_app/widgets/IoT/gauge.dart';
import 'package:iot_app/widgets/IoT/gauge_mult.dart';
import 'package:iot_app/widgets/IoT/switch.dart';
import 'package:iot_app/widgets/Notice/notice_snackbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Users? user;
  late Users storedData;
  bool isDataLoaded = false;
  late double x = 80;
  List<String> listIdDevice = [];
  List<Widget> widgetsList = [];
  List<Widgets> listWidgets = [];
  List<DraggableGridItem> draggableItems = [];

  @override
  void initState() {
    super.initState();
    fetchDeviceId();
    fetchgWidgetsList();
  }

  Future<void> fetchgWidgetsList() async {
    try {
      listWidgets = await FetchWidgetData.loadWidgets();
      widgetsList = toListWidget(listWidgets);
      draggableItems = widgetsList.map((widget) {
        return DraggableGridItem(
          //index: widgetsList.indexOf(widget),
          child: widget,
        );
      }).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchDeviceId() async {
    try {
      List<String> getAll = await DataFirebase().getAllDevice();
      if (getAll != null) {
        print(getAll);
        setState(() {
          listIdDevice = getAll;
        });
      }
    } catch (e) {
      showSnackBar(context, "Fail to fetch device id in firebase");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              _addWidget(listIdDevice);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            //height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                GridView.count(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2, // Số cột
                  crossAxisSpacing: 10, // Khoảng cách giữa các cột
                  mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                  padding: const EdgeInsets.only(bottom: 180),
                  children: [
                    const IoTGaugeMulti(
                      virtualPin: "V1",
                      name: "Temperature",
                      max: 100,
                      min: 0,
                      meter: "*C",
                    ),
                    const IoTGauge(
                      virtualPin: "V2",
                      name: "Huminity",
                      max: 100,
                      min: 0,
                      meter: "%",
                      color: Colors.blueAccent,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: IoTSwitch(
                        virtualPin: "A1",
                        nameSwitch: "Light Yellow",
                        colorSwitch: Colors.yellow,
                      ),
                    ),
                    ...widgetsList,
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void _addWidget(List<String> deviceIDs) {
    Color _selectedColor = Colors.red;
    String _selectedDeviceID = deviceIDs.isNotEmpty ? deviceIDs[0] : '';
    String _selectedType = WIDGET_TYPES[0];
    late TextEditingController _nameTextEditingController =
        TextEditingController();
    late TextEditingController _meterTextEditingController =
        TextEditingController();
    late TextEditingController _maxTextEditingController =
        TextEditingController();
    late TextEditingController _minTextEditingController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Widget"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Device ID"),
                DropdownMenu<String>(
                  initialSelection: deviceIDs.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedDeviceID = value!;
                    });
                  },
                  dropdownMenuEntries:
                      deviceIDs.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Text("Type"),
                DropdownMenu<String>(
                  initialSelection: WIDGET_TYPES.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedType = value!;
                      if (_selectedType == 'Switch') {
                        _meterTextEditingController.text = 'No Need';
                        _maxTextEditingController.text = '1';
                        _minTextEditingController.text = '0';
                      } else {
                        _meterTextEditingController.text = '';
                        _maxTextEditingController.text = '';
                        _minTextEditingController.text = '';
                      }
                    });
                  },
                  dropdownMenuEntries: WIDGET_TYPES
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Text("Name"),
                TextField(
                  controller: _nameTextEditingController,
                ),
                const SizedBox(height: 10),
                const Text("Meter"),
                TextField(controller: _meterTextEditingController),
                const SizedBox(height: 10),
                const Text("Max"),
                TextField(controller: _maxTextEditingController),
                const SizedBox(height: 10),
                const Text("Min"),
                TextField(controller: _minTextEditingController),
                const SizedBox(height: 10),
                const Text("Color for button/witch"),
                MaterialColorPicker(
                    onColorChange: (Color color) {
                      // Handle color changes
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    selectedColor: Colors.red),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                try {
                  // Lấy giá trị từ các trường nhập liệu
                  String name = _nameTextEditingController.text;
                  String deviceID = _selectedDeviceID;
                  String typeWidget = _selectedType;
                  String meter = _meterTextEditingController.text;
                  double max =
                      double.tryParse(_maxTextEditingController.text) ?? 0;
                  double min =
                      double.tryParse(_minTextEditingController.text) ?? 0;
                  if (min >= max) {
                    showSnackBar(context, "Please enter min < max");
                    throw e;
                  }
                  if (name.trim().isEmpty ||
                      deviceID.isEmpty ||
                      typeWidget.isEmpty) throw e;

                  Widgets w = Widgets(
                      id: deviceID,
                      type: typeWidget,
                      name: name,
                      meter: meter,
                      max: max,
                      min: min,
                      color: _selectedColor.toString());
                  setState(() {
                    listWidgets.add(w);
                    FetchWidgetData.addWidget(w);
                    widgetsList.add(w.toWidget());
                  });
                  showSnackBar(context, "Create successfully");
                } catch (e) {
                  print(e.toString());
                  showSnackBar(context, "Cannot create widget");
                }

                // Đóng hộp thoại
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
