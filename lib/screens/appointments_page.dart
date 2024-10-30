import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/screens/AppointmentDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importing the intl package
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
          stream:
              FirebaseFirestore.instance.collection('appointments').snapshots(),
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
                var appointment =
                    appointments[index].data() as Map<String, dynamic>;
                return _buildAppointmentCard(context, appointment);
              },
            );
          },
        ),
      ),
      bottomNavigationBar:
          BottomBarWidget(currentIndex: 1, onTabTapped: (int value) {}),
    );
  }

  // Helper method to build appointment cards
  Widget _buildAppointmentCard(
      BuildContext context, Map<String, dynamic> appointment) {
    // Format the appointment date and time
    DateTime appointmentDate =
        (appointment['appointmentDate'] as Timestamp).toDate();
    String formattedDate = DateFormat('MMMM d, yyyy').format(appointmentDate);
    String formattedTime = DateFormat('hh:mm a').format(appointmentDate);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          appointment['doctorName'] ?? 'Unknown Doctor',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.teal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Date: $formattedDate', style: const TextStyle(fontSize: 14)),
            Text('Time: $formattedTime', style: const TextStyle(fontSize: 14)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          // Navigate to the appointment detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AppointmentDetailPage(appointment: appointment),
            ),
          );
        },
      ),
    );
  }
}
