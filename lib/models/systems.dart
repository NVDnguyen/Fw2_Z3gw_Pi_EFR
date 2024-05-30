import 'package:iot_app/models/devices.dart';
import 'package:iot_app/models/system_log.dart';

class System {
  final String systemID;
  final String name;
  final List<Device> devices;
  final List<SystemLog> logs;

  System({
    required this.systemID,
    required this.name,
    required this.devices,
    required this.logs,
  });

  factory System.fromJson(String id, Map<String, dynamic> json) {
    final List<Device> devices = [];
    final List<SystemLog> logs = [];

    // Duyệt qua các mục trong JSON
    json.forEach((key, value) {
      // Xử lý mục 'log'
      if (key == 'log') {
        logs.addAll(
          (value as Map<String, dynamic>).entries.map(
                (entry) => SystemLog(entry.key, entry.value as String),
              ),
        );
      }
      // Xử lý mục 'name'
      else if (key == 'name') {
        // Không cần xử lý, giá trị được lấy trực tiếp
      }
      // Xử lý các mục khác (thiết bị)
      else {
        devices.add(Device.fromJson(id, key, value as Map<String, dynamic>));
      }
    });

    return System(
      systemID: id,
      name: json['name'] as String,
      devices: devices,
      logs: logs,
    );
  }

  @override
  String toString() {
    return 'System { systemID: $systemID, name: $name, devices: $devices, logs: $logs }';
  }
}
