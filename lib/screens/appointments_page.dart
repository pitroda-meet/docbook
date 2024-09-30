import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the HomePage

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAppointmentCard(
              'Dr. Anubhav (Dermatologist)',
              'Aug 25, 2024',
              '2:00 PM',
            ),
            _buildAppointmentCard(
              'Dr. Shreya (Cardiologist)',
              'Aug 25, 2024',
              '2:00 PM',
            ),
            _buildAppointmentCard(
              'Dr. Meenakshi (Gynaecologist)',
              'Aug 25, 2024',
              '2:00 PM',
            ),
            _buildAppointmentCard(
              'Dr. Yash (Orthopedic)',
              'Aug 25, 2024',
              '2:00 PM',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Highlight the Appointments icon as the current page
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Stay on AppointmentsPage (no action needed)
          } else if (index == 2) {
            // Add navigation for Dashboard or any other page
          } else if (index == 3) {
            // Add navigation for Settings or any other page
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 25),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps, size: 25),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 25),
            label: 'Settings',
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }

  // Helper method to build appointment cards
  Widget _buildAppointmentCard(String doctor, String date, String time) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(doctor, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Date: $date\nTime: $time'),
      ),
    );
  }
}
