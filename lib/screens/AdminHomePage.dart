import 'package:flutter/material.dart';
import 'manage_appointments.dart';  // Add appropriate admin pages
import 'manage_users.dart';
import 'manage_doctors.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
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
}
