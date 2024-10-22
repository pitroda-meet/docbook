import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../services/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  User? _user;
  String? _role; // Add a field to hold user role

  User? get user => _user;
  String? get role => _role; // Expose the role

  // Sign in user
  Future<void> signIn(String email, String password) async {
    _user = await _authService.signInWithEmail(email, password);

    if (_user != null) {
      // Check Firestore for user role
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        _role = userDoc['role']; // Assuming 'role' is the field in Firestore
      } else {
        // Handle case where user document does not exist
        _role = 'user'; // Default role
      }
    }

    notifyListeners(); // Update UI
  }

  // Sign out user
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _role = null; // Clear role on sign out
    notifyListeners(); // Update UI
  }

  // Check if the user is logged in
  bool isAuthenticated() {
    _user = _authService.getCurrentUser();
    return _user != null;
  }

  // Check if the user is an admin
  bool isAdmin() {
    return _role == 'admin';
  }
}
