import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'bottom_bar_widget.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading appointments.'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No appointments found.'));
            }

            // List of appointments from Firestore
            var appointments = snapshot.data!.docs;

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                var appointment = appointments[index].data() as Map<String, dynamic>;

                return _buildAppointmentCard(
                  appointment['doctor'] ?? 'Unknown Doctor',
                  appointment['date'] ?? 'Unknown Date',
                  appointment['time'] ?? 'Unknown Time',
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomBarWidget(currentIndex: 1, onTabTapped: (int value) {  },),
    );
  }

  // Helper method to build appointment cards
  Widget _buildAppointmentCard(String doctor, String date, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Date: $date\nTime: $time'),
      ),
    );
  }
}
