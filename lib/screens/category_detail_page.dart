import 'package:docbook/screens/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:docbook/screens/BookingPage.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Example list of doctors based on category
    final List<Doctor> doctors = _getDoctorsForCategory(categoryName);

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Doctors'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return _buildDoctorCard(
                context, doctor); // Pass context to handle navigation
          },
        ),
      ),
      bottomNavigationBar: const BottomBarWidget(currentIndex: 0),
    );
  }

  List<Doctor> _getDoctorsForCategory(String category) {
    // You can replace this with your own logic for fetching doctors per category
    List<Doctor> doctors = [
      Doctor('Dr. Amit', 'Specialist Cardiologist', 'assets/image 1.png'),
      Doctor('Dr. Shreya', 'Specialist Cardiologist', 'assets/image 2.png'),
      Doctor('Dr. Yash', 'Specialist Cardiologist', 'assets/image 3.png'),
    ];
    return doctors;
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(doctor.imagePath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    doctor.specialization,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to BookingPage when "Book Now" is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      doctorName: doctor.name,
                      specialization: doctor.specialization,
                      imagePath: doctor.imagePath,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialization;
  final String imagePath;

  Doctor(this.name, this.specialization, this.imagePath);
}
