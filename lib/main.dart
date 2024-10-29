import 'package:docbook/screens/AdminHomePage.dart';
import 'package:docbook/screens/Edit_Page.dart';
import 'package:docbook/screens/add_page.dart';
import 'package:docbook/screens/doctordash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/enter_code_screen.dart';
import 'screens/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/reset-password': (context) => const ResetPasswordScreen(resetCode: ''),
        '/home': (context) => const HomePage(),
        '/admin-home': (context) => const AdminHomePage(),
        '/doctor-dashboard': (context) => const DoctorDashboard(signedInUserEmail: '',), // Add route for Doctor Dashboard
        '/add-doctor': (context) => const AddPage(),
        '/edit': (context) => const EditPage(doctorId: ''), // EditPage route simplified to only pass doctorId
      },
    );
  }
}
