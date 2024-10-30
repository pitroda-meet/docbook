import 'package:docbook/screens/appointments_page.dart';
import 'package:flutter/material.dart';
import 'category_page.dart';
import 'settings_screen.dart';
import 'home_screen.dart';

class BottomBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const BottomBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

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
        onTabTapped(index); // Use the onTabTapped callback
        _onTabSelected(context, index); // Handle navigation here
      },
      items: const [
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

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppointmentsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const CategoryPage(categoryName: 'All Categories'),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }
}
