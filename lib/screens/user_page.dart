import 'package:flutter/material.dart';
import 'package:docbook/screens/add_page.dart';
import 'package:docbook/screens/admin_bottom_bar.dart';
import 'package:docbook/screens/AdminHomePage.dart';

// Example user model
class UserModel {
  String name;
  String email;
  String role;
  String imageUrl; // New field for user image

  UserModel(
      {required this.name,
      required this.email,
      required this.role,
      required this.imageUrl});
}

// UserPage that displays user details and allows changing roles
class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 2;

  // Sample user data with image URLs
  List<UserModel> users = [
    UserModel(
      name: 'John Doe',
      email: 'john@example.com',
      role: 'Admin',
      imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    ),
    UserModel(
      name: 'Jane Smith',
      email: 'jane@example.com',
      role: 'User',
      imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    ),
    UserModel(
      name: 'Mike Johnson',
      email: 'mike@example.com',
      role: 'Moderator',
      imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
    ),
  ];

  // Function to update user role
  void _updateUserRole(int index, String newRole) {
    setState(() {
      users[index].role = newRole;
    });
  }

  // Bottom navigation handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return _buildUserCard(context, users[index], index);
          },
        ),
      ),
      bottomNavigationBar: AdminBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Card to display user info with role change functionality
  Widget _buildUserCard(BuildContext context, UserModel user, int index) {
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
              backgroundImage:
                  NetworkImage(user.imageUrl), // Displaying user image
              backgroundColor: Colors.grey[200], // Placeholder color
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
                // DropdownButton to change user role
                DropdownButton<String>(
                  value: user.role,
                  items: <String>['Admin', 'User', 'Moderator']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateUserRole(index, newValue);
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
