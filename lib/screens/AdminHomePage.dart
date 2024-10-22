import 'package:docbook/screens/ManageAppointmentsScreen.dart';
import 'package:docbook/screens/ManageDoctorsScreen.dart';
import 'package:docbook/screens/ManageUsersScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docbook/screens/login_screen.dart'; // Import your LoginScreen

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Optional: You can log out here if desired, but this is now handled by the logout button.
        return true; // Allow the back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAdminButton(context, 'Manage Appointments', ManageAppointmentsScreen()),
              _buildAdminButton(context, 'Manage Users', ManageUsersScreen()),
              _buildAdminButton(context, 'Manage Doctors', ManageDoctorsScreen()),
              const SizedBox(height: 20), // Add some space
              _buildLogoutButton(context), // Add the logout button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: Colors.deepOrangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(title, style: const TextStyle(fontSize: 18.0)),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut(); // Sign out
        _showLogoutMessage(context); // Show logout message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to LoginScreen
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Logout', style: TextStyle(fontSize: 18.0)),
    );
  }

  void _showLogoutMessage(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Logged out successfully!'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar); // Show the SnackBar
  }
}
