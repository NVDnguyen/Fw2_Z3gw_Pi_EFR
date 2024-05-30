import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_app/models/users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Anonymous sign-in
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

  // Login user
  Future<Users> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      // Fetch data from Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userCredential.user!.uid);
      DataSnapshot snapshot = await userRef.get();
      Map<dynamic, dynamic>? userData =
          snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        // Create Users object from the retrieved data
        Map<String, dynamic> systems = userData['systems'] != null
            ? Map<String, dynamic>.from(userData['systems'])
            : {};

        Users user = Users(
          username: userData['user_name'],
          address: userData['address'],
          email: email,
          password: password,
          userID: userId,
          image: userData['image'],
          systems: systems,
        );
        return user;
      } else {
        throw Exception("User data not found in database");
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Register new user
  Future<bool> registerUser(Users user) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      String userId = userCredential.user!.uid;

      // Save user information to Realtime Database
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(userId);
      await userRef.set({
        'user_name': user.username,
        'address': user.address,
        'image': user.image,
        'systems': user.systems,
      });

      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  // Update user information
  Future<bool> updateUserInfo(Users user) async {
    try {
      // Update information in Realtime Database
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(user.userID);
      await userRef.update({
        'user_name': user.username,
        'address': user.address,
        'image': user.image,
        'systems': user.systems,
      });

      return true;
    } catch (e) {
      print('Error updating user info: $e');
      return false;
    }
  }
}
