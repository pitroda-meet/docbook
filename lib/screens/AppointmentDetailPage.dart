import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  // Helper method to get color and icon based on status
  Map<String, dynamic> _getStatusDetails(String status) {
    switch (status) {
      case 'pending':
        return {
          'color': Colors.orange,
          'icon': Icons.hourglass_empty,
        };
      case 'confirmed':
        return {
          'color': Colors.green,
          'icon': Icons.check_circle,
        };
      case 'cancelled':
        return {
          'color': Colors.red,
          'icon': Icons.cancel,
        };
      default:
        return {
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime appointmentDate =
        (appointment['appointmentDate'] as Timestamp).toDate();
    String formattedDate = DateFormat('MMMM d, yyyy').format(appointmentDate);
    String formattedTime = DateFormat('hh:mm a').format(appointmentDate);

    // Get color and icon based on appointment status
    final statusDetails = _getStatusDetails(appointment['status']);
    final statusColor = statusDetails['color'];
    final statusIcon = statusDetails['icon'];

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
                  // Doctor Info Section
                  Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. ${doctorDetails?['name'] ?? 'Unknown'}',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Specialization: ${doctorDetails?['specialist'] ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'Category: ${doctorDetails?['category'] ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.attach_money,
                                    color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  'Fees: ₹${appointment['doctorFees']}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  'Mobile: ${doctorDetails?['mobile'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Appointment Info Section
                  Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appointment Details',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Appointment Date: $formattedDate',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Appointment Time: $formattedTime',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Patient Info Section
                  Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient Details',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Name: ${appointment['patientName']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Age: ${appointment['patientAge']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Email: ${appointment['patientEmail']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Mobile: ${appointment['patientMobile']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Gender: ${appointment['patientGender']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Status Section
                  Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(statusIcon, color: statusColor),
                            const SizedBox(width: 8),
                            Text(
                              'Status: ${appointment['status']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
