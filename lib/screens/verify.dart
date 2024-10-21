import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _checkEmailVerification(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error: Could not verify email.');
            } else {
              return const Text('Email verified successfully! You can now log in.');
            }
          },
        ),
      ),
    );
  }

  Future<void> _checkEmailVerification() async {
    // Get the URL and extract the code
    Uri uri = Uri.parse('https://batch-a-project.firebaseapp.com/__/auth/action?mode=action&oobCode=code'); // Replace with the actual link
    String? oobCode = uri.queryParameters['oobCode'];

    if (oobCode != null) {
      try {
        // Verify the email address using the action code
        await FirebaseAuth.instance.applyActionCode(oobCode);
      } catch (e) {
        throw Exception('Error verifying email: $e');
      }
    } else {
      throw Exception('No action code found in the URL');
    }
  }
}
