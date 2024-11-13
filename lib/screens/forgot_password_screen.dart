import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of FirebaseAuth
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

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

  // Function to check if the user is an admin

// Function to check if the user is an admin
  Future<bool> _isAdminEmail(String email) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Check if any documents were found
      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data();
        return userData['role'] == 'admin'; // Ensure 'role' field exists
      }
    } catch (e) {
      print('Error checking admin email: $e'); // Log the error for debugging
    }
    return false; // Return false if no user found or an error occurred
  }

// Function to send a password reset email
  Future<void> _sendPasswordResetEmail() async {
    if (_formKey.currentState?.validate() == true) {
      String email = _emailController.text.trim(); // Trim whitespace

      // Check if the email belongs to an admin
      bool isAdmin = await _isAdminEmail(email);

      // If the email is from an admin, prevent sending a reset email
      if (isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Admins cannot reset their passwords through this method.'),
        ));
        return; // Exit if the email is for an admin
      }

      // Proceed to send password reset email for non-admin users
      try {
        await _auth.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Password reset email sent, if an account with that email exists.'),
        ));
        Navigator.pop(context); // Navigate back to the previous screen
      } on FirebaseAuthException catch (e) {
        // Handle errors specific to Firebase Auth
        _handleFirebaseAuthError(e);
      } catch (e) {
        // Handle any other unexpected errors
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('An unexpected error occurred. Please try again later.'),
        ));
      }
    }
  }

// Function to handle Firebase Auth errors
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No account found with this email.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Please try again later.';
        break;
      default:
        errorMessage = 'An error occurred. Please try again.';
        break;
    }
    // Show the error message to the user
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
    ));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/Frame.png', // Replace with your logo path
                height: 100,
              ),
              const SizedBox(height: 16.0),

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

              // Forgot Password Container
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Forgot Password Title
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Instruction Text
                      const Text(
                        'Enter your email to receive a password reset link.',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Email Input Field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 24.0),

                      // Continue Button
                      ElevatedButton(
                        onPressed: _sendPasswordResetEmail,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
