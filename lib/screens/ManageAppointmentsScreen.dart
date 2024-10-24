import 'package:flutter/material.dart';

class ManageAppointmentsScreen extends StatelessWidget {
  const ManageAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Appointments'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text('Manage Appointments Page', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
