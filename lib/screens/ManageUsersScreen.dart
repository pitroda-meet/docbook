import 'package:flutter/material.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text('Manage Users Page', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
