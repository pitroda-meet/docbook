import 'package:docbook/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'appointments_page.dart';
import 'category_page.dart'; // Import the category page
import 'settings_screen.dart';

class BottomBarWidget extends StatelessWidget {
  final int currentIndex;

  const BottomBarWidget({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppointmentsPage()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CategoryPage(categoryName: 'All Categories')),
          );
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
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
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: 25),
          label: 'Settings',
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }
}
