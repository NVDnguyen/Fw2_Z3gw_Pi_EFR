import 'package:iot_app/constants/properties.dart';

class Users {
  final String username;
  final String email;
  final String address;
  final String password;
  final String userID;
  final String image;
  final Map<String, dynamic> systems;

  // Constructor cho việc đăng nhập thành công
  Users({
    required this.userID,
    required this.username,
    required this.password,
    required this.email,
    required this.address,
    required this.image,
    required this.systems,
  });

  // Constructor for SharedPreferences
  Users.sharedPreferences({
    required this.userID,
    required this.username,
    required this.email,
    required this.address,
    required this.image,
  })  : password = '',
        systems = Map();

  // Constructor for Firebase RealTime
  Users.realTimeCloud({
    required this.userID,
    required this.username,
    required this.email,
    required this.address,
    required this.image,
    required this.systems,
  }) : password = '';

  // Constructor cho việc nhận thông tin đăng ký
  Users.register({
    required this.username,
    required this.password,
    required this.email,
    required this.address,
  })  : userID = '',
        image = IMAGE_DEFAULT,
        systems = {};

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userID: json['userID'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      address: json['address'],
      image: json['image'],
      systems: json['systems'] ?? {},
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
      'systems': systems,
    };
  }

  // Phương thức set cho username
  Users updateUser(String newUsername, String newAddress, String newImage) {
    return Users(
      userID: this.userID,
      username: newUsername,
      password: this.password,
      email: this.email,
      address: newAddress,
      image: newImage,
      systems: this.systems,
    );
  }

  // Phương thức lấy danh sách các ID trong systems
  List<String> getSystemIDs() {
    return systems.keys.toList();
  }
  Map<String, dynamic> getSystems() {
    return systems;
  }

  // Phương thức kiểm tra người dùng có phải admin của system hay không
  bool isAdmin(String systemID) {
    return systems[systemID]?['admin'] == 1;
  }

  @override
  String toString() {
    return 'Users{userID: $userID, username: $username, email: $email, address: $address, image: $image, systems: $systems}';
  }
}
