import 'package:flutter/material.dart';
import 'screens/backid.dart';
import 'screens/frontid.dart';
import 'screens/infor.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/signup': (context) => SignupScreen(),
        '/signin': (context) => SigninScreen(),
        '/frontid': (context) => FrontIdScreen(),
        '/backid': (context) => BackIdScreen(),
        '/infor': (context) => InforScreen(),
      },
    );
  }
}
