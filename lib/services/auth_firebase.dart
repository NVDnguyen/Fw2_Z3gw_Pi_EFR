import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_app/models/users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Users> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid; // Lấy User ID của người dùng
      // get info from realtime database
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userCredential.user!.uid);
      DataSnapshot snapshot = await userRef.get();
      Map<dynamic, dynamic>? userData =
          snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        // Tạo đối tượng Users từ dữ liệu lấy được từ Realtime Database
        Users user = Users(
          username: userData['user_name'],
          address: userData['address'],
          email: email,
          password: password,
          userID: userId,
          image: userData['image'],
        );
        return user;
      } else {
        throw Exception(
            "Không tìm thấy thông tin người dùng trong cơ sở dữ liệu");
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> registerUser(Users user) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      String userId = userCredential.user!.uid; // Lấy User ID của người dùng

      // Lưu thông tin người dùng vào Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userCredential.user!.uid);
      await userRef.set({      
        'user_name': user.username,
        'address': user.address,
        'image': user.image
        // Thêm các trường khác tùy ý
      });

      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  Future<bool> updateUserInfo(Users user) async {
  try {
    // 1. Cập nhật thông tin trong Realtime Database
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.userID);
    await userRef.set({
      'user_name': user.username,
      'address': user.address,
      'image': user.image,
    });  

    return true;
  } catch (e) {
    print('Error updating user info: $e');
    return false;
  }
}

}
