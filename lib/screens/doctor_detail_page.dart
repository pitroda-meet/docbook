import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/screens/BookingPage.dart';
import 'package:docbook/screens/bottom_bar_widget.dart';

class DoctorDetailPage extends StatelessWidget {
  final String doctorId;

  const DoctorDetailPage({
    super.key,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Doctor Details',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Doctor not found'));
          }

          final doctorData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Information Card
                Card(
                  elevation: 5,
                  shadowColor: Colors.teal.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              NetworkImage(doctorData['image_url'] ?? ''),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorData['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                doctorData['specialist'] ?? 'Specialist',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Display the doctor ID
                              Text(
                                'Doctor ID: ${doctorId}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingPage(
                                        doctorId: doctorId,
                                        doctorName:
                                            doctorData['name'] ?? 'No Name',
                                        specialization:
                                            doctorData['specialist'] ??
                                                'Specialist',
                                        imagePath:
                                            doctorData['image_url'] ?? '',
                                        doctorFees: doctorData['fees'] ??
                                            'Not Available', // Passing fees
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Book Appointment',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Additional Information Section
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(Icons.email, 'Email',
                            doctorData['email'] ?? 'Not Available'),
                        _buildDetailItem(Icons.local_hospital, 'Category',
                            doctorData['category'] ?? 'Not Available'),
                        _buildDetailItem(Icons.person, 'Gender',
                            doctorData['gender'] ?? 'Not Available'),
                        _buildDetailItem(Icons.business, 'Profession',
                            doctorData['profession'] ?? 'Not Available'),
                        _buildDetailItem(Icons.phone, 'Mobile',
                            doctorData['mobile'] ?? 'Not Available'),
                        _buildDetailItem(Icons.healing, 'GP Services',
                            doctorData['gp_services'] ?? 'Not Available'),
                        _buildDetailItem(
                            Icons.monetization_on,
                            'Fees',
                            doctorData['fees'] ??
                                'Not Available'), // Displaying fees
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: 0,
        onTabTapped: (int value) {},
      ),
    );
  }

  // Helper widget to display each detail item with an icon
  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
