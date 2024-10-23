import 'package:docbook/screens/AdminHomePage.dart'; // Admin home page import
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

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

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
  Future<String?> _getUserRole(String email) async {
    final userSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      String role = userSnapshot.docs.first.data()['role'];
      return role; // Return the role ('admin' or 'user')
    }
    return null; // No user found in Firestore
  }

  // Handle Login Submission
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      // Ensure email and password are not null
      if (email == null || password == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and Password cannot be empty.')),
        );
        return; // Exit if email or password is null
      }

      // Debug print for email and password
      print('Email: $email, Password: $password');

      try {
        // Log in with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);

        // Get user role from Firestore
        String? userRole = await _getUserRole(email!);

        if (userRole == null) {
          // No user found in Firestore, show appropriate error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('No user found with this email in the database.')),
          );
        } else {
          // If user is found, show success message and navigate
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful')),
          );

          // Navigate based on role
          if (userRole == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminHomePage(),
              ),
            );
          } else if (userRole == 'user') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        // Handle login failure
        String errorMessage;

        // Customize error messages based on error codes
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'Login Failed: ${e.message}';
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
        ));
      } catch (e) {
        // Handle any other errors
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
      backgroundColor: Colors.white,
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
                const Text(
                  'DocBook',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32.0),

                // Email Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onSaved: (value) => email = value,
                ),
                const SizedBox(height: 16.0),

                // Password Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
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
                ),
                const SizedBox(height: 16.0),

                // Login Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: Colors.teal,
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
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Sign Up Link
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/signup'); // Navigate to User Sign Up page
                  },
                  child: const Text(
                    'Don\'t have an account? Join us',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
