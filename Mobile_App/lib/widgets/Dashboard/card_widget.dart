import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardItem {
  final ImageProvider image;
  final String text;

  CardItem({
    required this.image,
    required this.text,
  });
}

class CardWidget extends StatelessWidget {
  final CardItem item;
  final bool isSelected;
  final VoidCallback onTap;

  CardWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blueAccent : Colors.white,
        child: Column(
          children: [
            Image(image: item.image, width: 100, height: 100),
            SizedBox(height: 8),
            Text(item.text, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}