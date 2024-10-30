import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importing the intl package

class AppointmentDetailPage extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailPage({super.key, required this.appointment});

  Future<Map<String, dynamic>?> _fetchDoctorDetails(String doctorId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Error fetching doctor details: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Format the appointment date and time
    DateTime appointmentDate =
        (appointment['appointmentDate'] as Timestamp).toDate();
    String formattedDate = DateFormat('MMMM d, yyyy').format(appointmentDate);
    String formattedTime = DateFormat('hh:mm a').format(appointmentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchDoctorDetails(appointment['doctorId']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading doctor details.'));
            }

            final doctorDetails = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor: ${doctorDetails?['name'] ?? 'Unknown'}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Specialization: ${doctorDetails?['specialist'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Category: ${doctorDetails?['category'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.teal),
                  const SizedBox(height: 16),
                  Text(
                    'Appointment Date: $formattedDate',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Appointment Time: $formattedTime',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Patient Name: ${appointment['patientName']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Patient Age: ${appointment['patientAge']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Patient Email: ${appointment['patientEmail']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Patient Mobile: ${appointment['patientMobile']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Patient Gender: ${appointment['patientGender']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Status: ${appointment['status']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
