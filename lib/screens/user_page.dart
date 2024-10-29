import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:docbook/screens/add_page.dart';
import 'package:docbook/screens/admin_bottom_bar.dart';
import 'package:docbook/screens/AdminHomePage.dart';

// User model class to represent Firestore user documents
class UserModel {
  String id;
  String name;
  String email;
  String role;
  String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.imageUrl,
  });

  // Factory method to create a UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 2;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to update user role in Firestore
  Future<void> _updateUserRole(String userId, String newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({'role': newRole});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role updated to $newRole')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update role: $error')),
      );
    }
  }

  // Bottom navigation handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _navigateBasedOnRole();
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPage()),
      );
    }
  }

  // Function to navigate based on user role
  void _navigateBasedOnRole() async {
    // Assuming you have the user's ID in context, fetch their role
    String userId = "currentUserId"; // Replace this with the actual user ID
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String role = userDoc['role'] ?? 'user';

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          List<UserModel> users = snapshot.data!.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUserCard(context, users[index]);
            },
          );
        },
      ),
      bottomNavigationBar: AdminBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Card to display user info with role change functionality
  Widget _buildUserCard(BuildContext context, UserModel user) {
    List<String> validRoles = ['admin', 'user'];
    String currentRole = validRoles.contains(user.role) ? user.role : 'user';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.imageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: currentRole,
                  items: validRoles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateUserRole(user.id, newValue);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
