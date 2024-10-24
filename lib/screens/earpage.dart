import 'package:flutter/material.dart';

class EarPage extends StatelessWidget {
  const EarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ear Doctors'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Dr. Emily Turner'),
            subtitle: Text('Specialist: Audiologist'),
            leading: Icon(Icons.hearing),
          ),
          ListTile(
            title: Text('Dr. Kevin Brown'),
            subtitle: Text('Specialist: ENT Surgeon'),
            leading: Icon(Icons.hearing),
          ),
          ListTile(
            title: Text('Dr. Alice Kim'),
            subtitle: Text('Specialist: Hearing Specialist'),
            leading: Icon(Icons.hearing),
          ),
        ],
      ),
    );
  }
}
