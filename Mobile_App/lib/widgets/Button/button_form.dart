import 'package:flutter/material.dart';

class ButtonFormWidget extends StatelessWidget {
  final String text;
 
  final Color colorButton;
  final Color colorText;
  final VoidCallback onPressed;

  const ButtonFormWidget(
      {super.key,
      required this.text,
   
      required this.colorButton,
      required this.colorText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(          
      onPressed: onPressed ,
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
