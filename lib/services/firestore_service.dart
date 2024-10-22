import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new document
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(uid).set(userData);
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  // Read user data
  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error reading user: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUser(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('users').doc(uid).update(updatedData);
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Delete a user
  Future<void> deleteUser(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
