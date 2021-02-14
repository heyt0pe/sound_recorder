import 'dart:async';
import 'index.dart';
import '../utils/size_config.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static const String id = 'splash_screen_page';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  /// Calling [navigate()] before the page loads
  @override
  void initState() {
    super.initState();
    navigate();
  }

  /// A function to set a 3 seconds timer for my splash screen to show
  /// and navigate to my [welcome] screen after
  void navigate() {
    Timer(
      Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacementNamed(Index.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Container(
        width: SizeConfig.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sound Recorder',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Circular Std Book',
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Group 7. Computer Science A',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Circular Std Book',
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
