import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final String text;

  const TitleTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      text,
      style: const TextStyle(
        
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold
      ),
    );
  }
}