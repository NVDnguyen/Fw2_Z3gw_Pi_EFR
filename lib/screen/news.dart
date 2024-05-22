import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {  
  
  @override
  _newScreenState createState() => _newScreenState();
}
class _newScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 248, 250, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 248, 250, 1),
        title:Text("News"),
      ),
    );
  }
  
}