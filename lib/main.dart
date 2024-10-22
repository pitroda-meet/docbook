import 'package:docbook/screens/AdminHomePage.dart';
import 'package:docbook/screens/AdminSignUpScreen.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart'; // Common Login for both User and Admin
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/enter_code_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/add_doctor_screen.dart'; // Admin: Add Doctor
import 'screens/doctor_list_screen.dart'; // Admin: Doctor List
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
        '/login': (context) => const LoginScreen(), // Common Login for User and Admin
        '/signup': (context) => const SignUpScreen(), // Common SignUp
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/enter-code': (context) => const EnterCodeScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(resetCode: ''),
        '/home': (context) => const HomePage(), // Home screen after login

        // Admin routes
        //'/': (context) => AdminHomePage(), // Update with your home screen widget
        '/admin-signup': (context) => const AdminSignUpScreen(),
        //'/admin-login': (context) => const AdminLoginScreen(), // Ensure this route is correctly defined
        '/add-doctor': (context) => AddDoctorScreen(), // Admin: Add Doctor
        '/doctor-list': (context) => DoctorListScreen(), // Admin: Doctor List
      },
    );
  }
}
