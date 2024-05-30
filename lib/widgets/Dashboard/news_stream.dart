import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iot_app/models/system_log.dart';
import 'package:iot_app/services/realtime_firebase.dart';

Widget buildInfoLogs({required String idSystem, required String nameSystems}) {
  Stream<List<SystemLog>> listLog = DataFirebase.getStreamLogs(idSystem);
  return StreamBuilder<List<SystemLog>>(
    stream: listLog,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text('No device data');
      }

      final data = snapshot.data!;
      return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data
                .map((log) => Text(nameSystems + "  " + log.toString()))
                .toList(),
          ));
    },
  );
}
