import 'package:docbook/screens/AdminHomePage.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Ensure this path is correct
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication

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
  bool isAdmin = false; // Toggle for user/admin mode

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Validate email
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

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Form Submission
Future<void> _submitForm() async {
  if (_formKey.currentState?.validate() == true) {
    _formKey.currentState?.save();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      // Check if the user is an admin or not (example: by checking Firestore roles)
      DocumentSnapshot userDoc = await _firestore.collection('users')
          .doc(userCredential.user!.uid).get();

      bool isAdmin = userDoc.get('role') == 'admin';

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login Successful'),
      ));

      // Navigate based on admin or user
      if (isAdmin) {
        Navigator.pushReplacement(
          context,
<<<<<<< HEAD
          MaterialPageRoute(builder: (context) => const AdminHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // User home screen
=======
          MaterialPageRoute(
              builder: (context) => const HomePage()), // Navigate to HomeScreen
>>>>>>> 6d6bc9055eaebe7165cd745ec5636888d4c7fa84
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Failed: ${e.message}'),
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
<<<<<<< HEAD
      backgroundColor: isAdmin ? Colors.black : Colors.white, // Toggle background color
      body: Padding(
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

              // App Title
              Text(
                'DocBook',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: isAdmin ? Colors.white : Colors.black, // Toggle text color
=======
      backgroundColor: Colors.white,
      // Fix overflow issue by setting resizeToAvoidBottomInset to true
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // Allow scrolling when keyboard appears
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                const Image(
                  image: AssetImage('assets/Frame.png'), // Ensure correct path
                  height: 100,
>>>>>>> 6d6bc9055eaebe7165cd745ec5636888d4c7fa84
                ),
                const SizedBox(height: 16.0),

<<<<<<< HEAD
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

              // Don't have an account? Sign Up
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup'); // Navigate to Sign Up page
                },
                child: Text(
                  'Don\'t have an account? Join us',
                  style: TextStyle(
                    color: isAdmin ? Colors.red : Colors.teal, // Toggle link color
                  ),
                ),
              ),
            ],
=======
                // App Title
                const Text(
                  'DocBook',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32.0),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        child: const Text('Login',
                            style: TextStyle(fontSize: 18.0)),
                      ),
                      const SizedBox(height: 16.0),

                      // Forgot Password Link
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text(
                          'Forgot password',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Don't have an account? Sign Up
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/signup'); // Navigate to Sign Up page
                        },
                        child: const Text(
                          'Don\'t have an account? Join us',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
>>>>>>> 6d6bc9055eaebe7165cd745ec5636888d4c7fa84
          ),
        ),
      ),
      // Add a toggle button at the bottom-right corner
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAdmin = !isAdmin; // Toggle between User and Admin mode
          });
        },
        backgroundColor: isAdmin ? Colors.red : Colors.teal, // Toggle button color
        child: Icon(
          isAdmin ? Icons.person : Icons.admin_panel_settings, // Icon switch for User/Admin
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Square shape for button
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position at bottom-right
    );
  }
}
