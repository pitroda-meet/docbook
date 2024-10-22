import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  // Fetch user data
  Future<void> fetchUserData(String uid) async {
    _userData = await _firestoreService.getUser(uid);
    notifyListeners();
  }

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> newData) async {
    await _firestoreService.updateUser(uid, newData);
    _userData = newData;
    notifyListeners();
  }
}
