import 'package:docbook/screens/category_page.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart'; // Import the login screen
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart'; // Import the home screen
import 'screens/enter_code_screen.dart'; // Import the home screen

import 'screens/reset_password_screen.dart'; // Import the home screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocBook',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(), // Add route to LoginScreen
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomePage(), // Add route for the home screen
        '/enter-code': (context) => EnterCodeScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
      },
    );
  }
}
