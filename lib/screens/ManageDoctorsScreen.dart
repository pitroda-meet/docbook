import 'package:flutter/material.dart';

class ManageDoctorsScreen extends StatelessWidget {
  const ManageDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Doctors'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text('Manage Doctors Page', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
