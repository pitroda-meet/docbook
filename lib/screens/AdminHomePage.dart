import 'package:docbook/screens/add_page.dart';
import 'package:docbook/screens/admin_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docbook/screens/login_screen.dart';
import 'package:docbook/screens/edit_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the tapped index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Colors.teal,
          elevation: 0,
          toolbarHeight: 100,
          actions: [
            _buildPopupMenu(context),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
<<<<<<< HEAD
              _buildAdminButton(context, 'Manage Appointments', const ManageAppointmentsScreen()),
              _buildAdminButton(context, 'Manage Users', const ManageUsersScreen()),
              _buildAdminButton(context, 'Manage Doctors', const ManageDoctorsScreen()),
              const SizedBox(height: 20), // Add some space
              _buildLogoutButton(context), // Add the logout button
=======
              Expanded(
                child: ListView(
                  children: [
                    _buildDoctorCard(context, 'Dr. Amit',
                        'Specialist Cardiologist', 'assets/image 1.png'),
                    _buildDoctorCard(context, 'Dr. Shreya',
                        'Specialist Gynaecologist', 'assets/image 2.png'),
                    _buildDoctorCard(context, 'Dr. Yash',
                        'Specialist Orthopaedic', 'assets/image 3.png'),
                    _buildDoctorCard(context, 'Dr. Meenakshi',
                        'Specialist Dentist', 'assets/image 4.png'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
>>>>>>> 148356394bd0bae492a2ec6ef3a445f2f99d2456
            ],
          ),
        ),
        bottomNavigationBar: AdminBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          _logout(context);
        }
      },
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'logout',
            child: Text('Logout'),
          ),
        ];
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, String doctorName,
      String specialization, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    specialization,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                          doctorName: doctorName,
                          specialization: specialization,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Edit'),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    // Handle delete
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _showLogoutMessage(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showLogoutMessage(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Logged out successfully!'),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
