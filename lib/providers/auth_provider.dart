import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  User? _user;

  User? get user => _user;

  // Sign in user
  Future<void> signIn(String email, String password) async {
    _user = await _authService.signInWithEmail(email, password);
    notifyListeners(); // Update UI
  }

  // Sign out user
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners(); // Update UI
  }

  // Check if the user is logged in
  bool isAuthenticated() {
    _user = _authService.getCurrentUser();
    return _user != null;
  }
}
