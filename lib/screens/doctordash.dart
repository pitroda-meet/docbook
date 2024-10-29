import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class DoctorDashboard extends StatelessWidget {
  final String signedInUserEmail; // Add this variable to hold the signed-in user's email

  const DoctorDashboard({Key? key, required this.signedInUserEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('status', isEqualTo: 'pending') // Only show pending requests
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending requests.'));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final userData = appointment.data() as Map<String, dynamic>;
              final userName = userData['userName'] ?? 'Patient';
              final userEmail = userData['userEmail'] ?? 'No Email';

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(userName),
                  subtitle: Text(userEmail),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          // Accept the request
                          FirebaseFirestore.instance
                              .collection('appointments')
                              .doc(appointment.id)
                              .update({'status': 'accepted'}).then((_) {
                            // Send confirmation email to the signed-in user
                            _sendConfirmationEmail(signedInUserEmail);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          // Reject the request
                          FirebaseFirestore.instance
                              .collection('appointments')
                              .doc(appointment.id)
                              .update({'status': 'rejected'});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method to send confirmation email
  void _sendConfirmationEmail(String userEmail) async {
    String username = 'your_email@example.com'; // Your email
    String password = 'your_email_password'; // Your email password

    // Set up the SMTP server
    final smtpServer = gmail(username, password); // For Gmail

    // Create the email message
    final message = Message()
      ..from = Address(username)
      ..recipients.add(userEmail)
      ..subject = 'Appointment Booked Successfully'
      ..text = 'Your appointment has been successfully booked.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }
}
