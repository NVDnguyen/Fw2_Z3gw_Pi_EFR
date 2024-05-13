import 'package:flutter/material.dart';
import 'package:iot_app/screen/home.dart';
import 'package:iot_app/screen/news.dart';
import 'package:iot_app/screen/profile.dart';


class Layout extends StatefulWidget {
  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<Layout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    NewsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

          // Thêm các bottom navigation bar item khác vào đây nếu cần
        ],
      ),
    );
  }
}
