// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/screen/login.dart';
import 'package:iot_app/services/auth_firebase.dart';
import 'package:iot_app/widgets/Button/button_form.dart';
import 'package:iot_app/widgets/Button/button_social.dart';
import 'package:iot_app/widgets/Notice/notice_snackbar.dart';
import 'package:iot_app/widgets/Text/passw_field.dart';
import 'package:iot_app/widgets/Text/text_button.dart';
import 'package:iot_app/widgets/Text/text_field.dart';
import 'package:iot_app/widgets/Text/text_title.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _registerScreenState createState() => _registerScreenState();
}

class _registerScreenState extends State<RegisterScreen> {
  late TextEditingController _userNameEditingController;
  late TextEditingController _emailEditingController;
  late TextEditingController _addressNameEditingController;
  late TextEditingController _passwordNameEditingController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _userNameEditingController = TextEditingController();
    _emailEditingController = TextEditingController();
    _addressNameEditingController = TextEditingController();
    _passwordNameEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _userNameEditingController.dispose();
    _emailEditingController.dispose();
    _addressNameEditingController.dispose();
    _passwordNameEditingController.dispose();
    super.dispose();
  }

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(247, 248, 250, 1),
        body: !isLoading
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const SizedBox(
                      child: TitleTextWidget(text: "Create"),
                    ),
                    const SizedBox(
                      child: TitleTextWidget(text: "Your Account"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 40),
                      child: Center(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFieldtWidget(
                                labelText: "User Name",
                                textEditingController:
                                    _userNameEditingController,
                                icon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter user name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldtWidget(
                                labelText: "Email",
                                textEditingController: _emailEditingController,
                                icon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldtWidget(
                                labelText: "Address",
                                textEditingController:
                                    _addressNameEditingController,
                                icon: Icons.account_balance_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              PasswordFieldWidget(
                                labelText: "Password",
                                textEditingController:
                                    _passwordNameEditingController,
                                icon: Icons.lock_clock_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ButtonFormWidget(
                                colorButton:
                                    const Color.fromARGB(255, 9, 11, 90),
                                colorText: Colors.white,
                                text: "Register",
                                onPressed: () {
                                  // Validate form

                                  if (_formKey.currentState!.validate()) {
                                    // If form is valid, proceed with login action
                                    _register(context);
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already Have An Account ?",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 150, 147, 147)),
                                    ),
                                    TextButtonWidget(
                                        buttonText: "Sign in",
                                        screen: LoginScreen())
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color.fromARGB(255, 150, 147, 147),
                                height: 50,
                              ),
                              SocialButtonRow(
                                  onGooglePressed: () {},
                                  onFacebookPressed: () {}),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }

  Future<void> _register(BuildContext context) async {
    try {
      String username = _userNameEditingController.text;
      String email = _emailEditingController.text;
      String address = _addressNameEditingController.text;
      String password = _passwordNameEditingController.text;
      Users user = Users.register(
          username: username,
          password: password,
          email: email,
          address: address);
      // store in firebase
      if (await _auth.registerUser(user)) {
        _showEmailVerificationDialog(user);
        print("Register successfully");
        // showSnackBar(context, "Register Successfully");
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        print("Register Fail");
        showSnackBar(context, "Register Fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showEmailVerificationDialog(Users user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verify Your Email'),
          content: Text(
              'A verification link has been sent to your email. Please verify your email to continue.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Resend Verification Email'),
              onPressed: () async {
                try {
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    await _auth.resendVerificationEmail(currentUser);
                    showSnackBar(context, "Verification email resent");
                  }
                } catch (e) {
                  print("Error resending verification email: $e");
                  showSnackBar(context, "Error resending verification email");
                  return;
                }
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                _checkEmailVerified(user);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _checkEmailVerified(Users user) {
    Timer.periodic(Duration(seconds: 3), (timer) async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
        if (currentUser.emailVerified) {
          timer.cancel();
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, "Email verified! Logging in...");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      }
    });
  }
}
