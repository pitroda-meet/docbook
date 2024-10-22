import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/enter_code_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/add_doctor_screen.dart'; // Add this import for the Add Doctor screen
import 'screens/doctor_list_screen.dart'; // Add this import for the Doctor List screen
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocBook',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(), // Start with SplashScreen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/enter-code': (context) => const EnterCodeScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(resetCode: ''),
        '/home': (context) => const HomePage(), // Home screen after login
        '/add-doctor': (context) => AddDoctorScreen(), // Add route for Add Doctor screen
        '/doctor-list': (context) => DoctorListScreen(), // Add route for Doctor List screen
      },
    );
  }
}
