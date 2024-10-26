import 'package:docbook/screens/AppointmentScreen.dart';
import 'package:docbook/screens/bottom_bar_widget.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final String imagePath;

  const BookingPage({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.imagePath,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _currentIndex = 0; // State to keep track of the selected index
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
  final DateTime _selectedDay = DateTime.now();
  final TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Book Appointment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Add SingleChildScrollView to prevent pixel overflow and allow scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display doctor information
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(widget.imagePath),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctorName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.specialization,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Patient's Name
              const Text('Patient\'s Name'),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Age Section
              const Text('Age'),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  hintText: 'Enter Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Gender Selection
              const Text('Gender'),
              Row(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value.toString();
                          });
                        },
                      ),
                      const Text('Male'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value.toString();
                          });
                        },
                      ),
                      const Text('Female'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Others',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value.toString();
                          });
                        },
                      ),
                      const Text('Others'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Mobile Number
              const Text('Mobile Number'),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Email
              const Text('Email'),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Booking Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to AppointmentScreen and pass selected data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(
                        doctorName: widget.doctorName,
                        specialization: widget.specialization,
                        selectedDate: _selectedDay,
                        selectedTime: _selectedTime,
                        patientName: _nameController.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text('Confirm Booking'),
              ),
              const SizedBox(height: 35), // Add spacing to avoid bottom navigation overlap
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index; // Update the current index when a tab is selected
          });
        },
      ),
    );
  }
}
