import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_app/models/system_log.dart';
import 'package:iot_app/services/realtime_firebase.dart';

Widget buildInfoLogs({required List<String> idSystem}) {
  if (idSystem.isEmpty) {
    return SizedBox();
  }
  Stream<List<SystemLog>> listLog = DataFirebase.getStreamLogs(idSystem);
  return StreamBuilder<List<SystemLog>>(
    stream: listLog,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No device data'));
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
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final log = data[index];
            // Format the timestamp
            final DateTime dateTime = DateTime.parse(log.timestamp);
            final String formattedDate =
                DateFormat('dd-MM-yyyy – kk:mm:ss').format(dateTime);
            return Card(
              color: Color.fromARGB(255, 226, 246, 253),
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      log.message,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
