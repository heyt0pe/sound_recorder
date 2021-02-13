import 'package:flutter/material.dart';
import 'ui/splash-screen.dart';
import 'ui/index.dart';
import 'ui/bottom_navs/record.dart';
import 'ui/bottom_navs/recordings.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Recorder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xFF004E92),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        Index.id: (context) => Index(),
      },
    );
  }
}
