import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String buttonText;
  final Widget screen;

  const TextButtonWidget(
      {Key? key, required this.buttonText, required this.screen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(

     
      child: 
      TextButton(
       
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Text(buttonText),
      ),
    );
  }
}
