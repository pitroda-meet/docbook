import 'package:flutter/material.dart';

class BodyPage extends StatelessWidget {
  const BodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Doctors'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Dr. John Smith'),
            subtitle: Text('Specialist: General Body Health'),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text('Dr. Lisa Martin'),
            subtitle: Text('Specialist: Physical Therapist'),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text('Dr. Susan Lee'),
            subtitle: Text('Specialist: Orthopedic Surgeon'),
            leading: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
