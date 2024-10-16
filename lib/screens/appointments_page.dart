import 'package:docbook/screens/bottom_bar_widget.dart';
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
      bottomNavigationBar: BottomBarWidget(currentIndex: 1),
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
