import 'package:flutter/material.dart';

Color stringToColor(String colorString) {
  // Loại bỏ các ký tự không cần thiết
  colorString = colorString.replaceAll("Color(", "").replaceAll(")", "");

  // Tách lấy giá trị hex
  String hexString = colorString.split("0x")[1];

  // Chuyển đổi từ chuỗi hex sang số nguyên
  int value = int.parse(hexString, radix: 16);

  // Tạo màu từ giá trị số nguyên và đảm bảo không trong suốt
  return Color(value).withOpacity(1.0);
}
