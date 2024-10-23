<<<<<<< HEAD
=======
import 'package:docbook/screens/AdminHomePage.dart';
import 'package:docbook/screens/add_page.dart';
import 'package:docbook/screens/edit_page.dart';
>>>>>>> 148356394bd0bae492a2ec6ef3a445f2f99d2456
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/enter_code_screen.dart';
import 'screens/reset_password_screen.dart';
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
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/enter-code': (context) => const EnterCodeScreen(),
<<<<<<< HEAD
        '/reset-password': (context) => const ResetPasswordScreen(resetCode: ''),
        '/home': (context) => const HomePage(), // Home screen after login

        // Admin routes
        //'/': (context) => AdminHomePage(), // Update with your home screen widget
        //'/admin-login': (context) => const AdminLoginScreen(), // Ensure this route is correctly defined
        '/add-doctor': (context) => const AddDoctorScreen(), // Admin: Add Doctor
        '/doctor-list': (context) => const DoctorListScreen(), // Admin: Doctor List
=======
        '/reset-password': (context) =>
            const ResetPasswordScreen(resetCode: ''),
        '/home': (context) => const HomePage(),
        '/admin-home': (context) => const AdminHomePage(), // Update route name
        '/add-doctor': (context) => const AddPage(),
        '/edit': (context) => const EditPage(
            doctorName: '', specialization: ''), // Update constructor call
>>>>>>> 148356394bd0bae492a2ec6ef3a445f2f99d2456
      },
    );
  }
}
