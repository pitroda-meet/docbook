import 'package:flutter/material.dart';

class AdminBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _AdminBottomBarState createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          // New Users item
          icon: Icon(Icons.people),
          label: 'Users',
        ),
      ],
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.teal,
      onTap: widget.onTap,
    );
  }
}
