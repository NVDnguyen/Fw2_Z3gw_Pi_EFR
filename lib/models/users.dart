import 'package:iot_app/constants/properties.dart';

class Users {
  final String username;
  final String email;
  final String address;
  final String password;
  final String userID;
  final String image;

  // Constructor cho việc đăng nhập thành công
  Users({
    required this.userID,
    required this.username,
    required this.password,
    required this.email,
    required this.address,
    required this.image,
  });
  // Constructor for SharedPreferences
  Users.sharedPreferences({
    required this.userID,
    required this.username,
    required this.email,
    required this.address,
    required this.image,
  }) : password = '';
  // Constructor cho việc nhân thông tin đăng ký
  Users.register({
    required this.username,
    required this.password,
    required this.email,
    required this.address,
  })  : userID = '',
        image = IMAGE_DEFAULT; // Mặc định userID là rỗng khi đăng ký thành công
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userID: json['userID'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      address: json['address'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'password': password,
      'email': email,
      'address': address,
      'image': image,
    };
  }

  // Phương thức set cho username
  Users updateUser(String newUsername, String address, String image) {
    return Users(
      userID: this.userID,
      username: newUsername,
      password: this.password,
      email: this.email,
      address: address,
      image: image,
    );
  }
}
