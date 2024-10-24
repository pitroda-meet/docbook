import 'package:flutter/material.dart';
class LungsPage extends StatelessWidget {
  const LungsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lungs Doctors'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Dr. Robert Green'),
            subtitle: Text('Specialist: Pulmonologist'),
            leading: Icon(Icons.air),
          ),
          ListTile(
            title: Text('Dr. Sarah Clark'),
            subtitle: Text('Specialist: Respiratory Therapist'),
            leading: Icon(Icons.air),
          ),
          ListTile(
            title: Text('Dr. Anna Thompson'),
            subtitle: Text('Specialist: Thoracic Surgeon'),
            leading: Icon(Icons.air),
          ),
        ],
      ),
    );
  }
}
