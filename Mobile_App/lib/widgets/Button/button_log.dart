import 'package:flutter/material.dart';

class ButtonLogWidget extends StatelessWidget {
  final String text;
  final Widget screenToNavigate;
  final Color colorButton;
  final Color colorText;

  const ButtonLogWidget(
      {super.key,
      required this.text,
      required this.screenToNavigate,
      required this.colorButton,
      required this.colorText});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(          
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screenToNavigate));
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: colorButton,
        minimumSize: const Size(double.infinity, 50)
        
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colorText,
          fontSize: 15,
        ),
      ),
      
      
    );

    
  }
}