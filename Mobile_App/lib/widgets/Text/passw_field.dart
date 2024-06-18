import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatefulWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final IconData icon;
  final String? Function(String?)? validator;

  const PasswordFieldWidget({
    Key? key,
    required this.labelText,
    required this.textEditingController,
    required this.icon,
    this.validator,
  }) : super(key: key);

  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: _isObscured,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        prefixIconColor: Color.fromARGB(255, 167, 165, 165),
        hintText: widget.labelText,
        hintStyle: TextStyle(color: Color.fromARGB(255, 167, 165, 165)),
        filled: true, // Set filled to true to enable background color
        fillColor: Colors.white, // Set background color to white
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none, // Remove the black border
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Color.fromARGB(255, 167, 165, 165),
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
    );
  }
}
