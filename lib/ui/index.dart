import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bottom_navs/recordings.dart';
import 'bottom_navs/record.dart';

/// A stateful widget class to display the home page
class Index extends StatefulWidget {
  static const String id = 'index_page';

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  /// Current index of the bottom navigation
  int currentIndex = 0;

  /// Navigating classes for the bottom navigation
  final List<Widget> _children = [
    Record(),
    Recordings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFF),
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0XFF004282),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Circular Std Book',
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Circular Std Book',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: Color(0XFFFFFFFF),
        unselectedItemColor: Color(0XFF888888),
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic_none,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.mic,
              size: 30,
            ),
            label: 'Sound Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              size: 30,
            ),
            label: 'Recordings',
          ),
        ],
      ),
    );
  }

  /// Navigating to other bottom tabs
  void _onTabTapped(int index) {
    if (!mounted) return;
    setState(() {
      currentIndex = index;
    });
  }
}
