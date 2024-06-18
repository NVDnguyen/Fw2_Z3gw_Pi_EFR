import 'package:flutter/material.dart';
import 'package:iot_app/models/system_log.dart';

void showNotificationsDialog(
    BuildContext context, List<SystemLog> notifications) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(16), // Khoảng cách so với cạnh màn hình
        child: Container(
          // Chiều cao tối đa của dialog (điều chỉnh theo ý muốn)
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Recent Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(notifications[index].timestamp),
                      subtitle: Text(notifications[index].message),
                      onTap: () {
                        // Xử lý khi người dùng nhấn vào thông báo
                        // Ví dụ: Hiển thị chi tiết thông báo
                      },
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                },
                icon: const Icon(
                  Icons.skip_previous,
                  color: Color.fromARGB(255, 194, 77, 214),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
