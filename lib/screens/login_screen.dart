import 'package:docbook/screens/AdminHomePage.dart'; // Admin home page import
import 'package:docbook/screens/AdminSignUpScreen.dart'; // Admin Sign Up import
import 'package:docbook/screens/home_screen.dart'; // Regular user home screen
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isPasswordVisible = false;
  bool isAdmin = false; // Toggle for admin mode

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  // Email Validator
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Password Validator
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Check if email belongs to admin or user
  Future<String> _getUserRole(String email) async {
    final adminSnapshot = await _firestore.collection('admins').where('email', isEqualTo: email).get();
    if (adminSnapshot.docs.isNotEmpty) {
      return 'admin'; // User is admin
    }

    final userSnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
    if (userSnapshot.docs.isNotEmpty) {
      return 'user'; // User is regular user
    }

    return 'none'; // User not found
  }

  // Handle Login Submission
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      try {
        // Log in with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);

        // Get user role
        String userRole = await _getUserRole(email!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );

        // Navigate based on role
        if (userRole == 'admin') {
          // Navigate to AdminHomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomePage(),
            ),
          );
        } else if (userRole == 'user') {
          // Navigate to HomePage for regular users
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          // Handle user not found (invalid login)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found with this email.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Failed: ${e.message}'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      backgroundColor: isAdmin ? Colors.black : Colors.white, // Toggle background color
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/Frame.png'), // Ensure correct path
                  height: 100,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'DocBook',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: isAdmin ? Colors.white : Colors.black, // Toggle text color
                  ),
                ),
                const SizedBox(height: 32.0),

                // Email Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: isAdmin ? Colors.white : Colors.black, // Toggle label color
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onSaved: (value) => email = value,
                  style: TextStyle(
                    color: isAdmin ? Colors.white : Colors.black, // Toggle input text color
                  ),
                ),
                const SizedBox(height: 16.0),

                // Password Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: isAdmin ? Colors.white : Colors.black, // Toggle label color
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: isAdmin ? Colors.white : Colors.black, // Toggle icon color
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                  validator: _validatePassword,
                  onSaved: (value) => password = value,
                  style: TextStyle(
                    color: isAdmin ? Colors.white : Colors.black, // Toggle input text color
                  ),
                ),
                const SizedBox(height: 16.0),

                // Login Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: isAdmin ? Colors.red : Colors.teal, // Toggle button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18.0)),
                ),
                const SizedBox(height: 16.0),

                // Forgot Password Link
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: Text(
                    'Forgot password',
                    style: TextStyle(
                      color: isAdmin ? Colors.red : Colors.teal, // Toggle link color
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Sign Up Link
                GestureDetector(
                  onTap: () {
                    if (isAdmin) {
                      // If admin mode, navigate to AdminSignUpScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminSignUpScreen(),
                        ),
                      );
                    } else {
                      // Regular user sign-up page navigation
                      Navigator.pushNamed(context, '/signup'); // Navigate to User Sign Up page
                    }
                  },
                  child: Text(
                    'Don\'t have an account? Join us',
                    style: TextStyle(
                      color: isAdmin ? Colors.red : Colors.teal, // Toggle link color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Admin/User Toggle Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAdmin = !isAdmin; // Toggle between User and Admin mode
          });
        },
        backgroundColor: isAdmin ? Colors.red : Colors.teal, // Toggle button color
        child: Icon(
          isAdmin ? Icons.admin_panel_settings : Icons.person, // Icon switch for User/Admin
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Bottom-right position
    );
  }
}
