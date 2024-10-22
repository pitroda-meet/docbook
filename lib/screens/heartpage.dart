import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class HeartPage extends StatelessWidget {
  const HeartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Doctors'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Dr. Thomas King'),
            subtitle: Text('Specialist: Cardiologist'),
            leading: Icon(Icons.favorite),
          ),
          ListTile(
            title: Text('Dr. Lisa Morgan'),
            subtitle: Text('Specialist: Heart Surgeon'),
            leading: Icon(Icons.favorite),
          ),
          ListTile(
            title: Text('Dr. Jonathan White'),
            subtitle: Text('Specialist: Cardiovascular Specialist'),
            leading: Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}
