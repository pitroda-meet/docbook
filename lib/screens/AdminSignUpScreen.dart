import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({super.key});

  @override
  _AdminSignUpScreenState createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? password;
  bool isPasswordVisible = false;
  bool isTermsAccepted = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Email Validation
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

  // Password Validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Name Validation
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // Form Submission
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true && isTermsAccepted) {
      _formKey.currentState?.save();

      try {
        // Create user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        // Save user info in Firestore, possibly under an 'admins' collection
        await _firestore.collection('admins').doc(userCredential.user?.uid).set({
          'name': name,
          'email': email,
          'signupTime': FieldValue.serverTimestamp(),
        });

        // Send verification email with custom content
        await userCredential.user?.sendEmailVerification(ActionCodeSettings(
          url: 'https://batch-a-project.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
          handleCodeInApp: true,
          androidPackageName: 'com.example.docbook', // Android package
          iOSBundleId: 'com.example.docbook', // iOS bundle
          androidInstallApp: true,
        ));

        // Display confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent. Check your inbox.')),
        );

        // Redirect to the common login screen
        Navigator.pushReplacementNamed(context, '/login'); // Updated to redirect to the common login screen
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Email is already in use.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          case 'weak-password':
            errorMessage = 'Weak password.';
            break;
          default:
            errorMessage = 'Sign Up Failed: ${e.message}';
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else if (!isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the terms and conditions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        backgroundColor: Colors.black, // Darker admin theme color
      ),
      backgroundColor: Colors.grey[200], // Light grey background
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/Frame.png'), // Custom admin logo
                height: 100,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Admin Panel',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateName,
                      onSaved: (value) => name = value,
                    ),
                    const SizedBox(height: 16.0),

                    // Email Field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
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
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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

                    // Terms and Conditions Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: isTermsAccepted,
                          onChanged: (value) {
                            setState(() {
                              isTermsAccepted = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'I agree with the Terms of Service & Privacy Policy',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.black87, // Darker admin button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Sign Up', style: TextStyle(fontSize: 18.0)),
                    ),
                    const SizedBox(height: 16.0),

                    // Already have an account? Log In link
                    GestureDetector(
                       onTap: () {
        Navigator.pushReplacementNamed(context, '/login'); // Redirect to admin login
    },
    child: const Text(
        'Already an admin? Log in',
        style: TextStyle(color: Colors.black87),
    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
