import 'package:docbook/screens/AppointmentScreen.dart';
import 'package:docbook/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final String imagePath;

  BookingPage({
    required this.doctorName,
    required this.specialization,
    required this.imagePath,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _currentIndex = 0; // Index for the bottom navigation bar
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male'; // Default gender selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Book Appointment'),
        centerTitle: true,
      ),
      body: Padding(
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
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctorName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.specialization,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Patient's Name
            Text('Patient\'s Name'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Age Section
            Text('Age'),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                hintText: 'Enter Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            // Gender Selection
            Text('Gender'),
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
                    Text('Male'),
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
                    Text('Female'),
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
                    Text('Others'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),

            // Mobile Number
            Text('Mobile Number'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Email
            Text('Email'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Confirm Booking Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the AppointmentScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AppointmentScreen(), // Pass necessary data if required
                  ),
                );
              },
              child: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Updated to backgroundColor
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation based on selected index
          switch (index) {
            case 0:
              // Navigate to Home
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              break;
            case 1:
              // Navigate to Appointments
              // Implement the navigation logic for appointments
              break;
            case 2:
              // Navigate to Dashboard
              // Implement the navigation logic for dashboard
              break;
            case 3:
              // Navigate to Settings
              // Implement the navigation logic for settings
              break;
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
}
