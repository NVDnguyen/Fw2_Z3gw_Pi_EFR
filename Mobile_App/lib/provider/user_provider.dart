import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';

class UserProvider extends ChangeNotifier {
  Users ? _user;
  Users? get user => _user;
  void updateUser(Users newUser) {
    _user = newUser;
    notifyListeners();
  }
}
