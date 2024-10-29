import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String phoneNumber;
  final String email;
  final String imageUrl; // Make sure to include imageUrl

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phoneNumber,
    required this.email,
    required this.imageUrl,
  });

  // Convert Doctor instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phoneNumber': phoneNumber,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  // Factory method to create Doctor from Firestore document
  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Doctor(
      id: doc.id, // Use document ID
      name: data['name'] ?? '',
      specialty: data['specialty'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '', // Default to empty string if null
    );
  }
}
