import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class BrainPage extends StatelessWidget {
  const BrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Doctors'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Dr. Rachel Adams'),
            subtitle: Text('Specialist: Neurologist'),
            leading: Icon(Icons.psychology),
          ),
          ListTile(
            title: Text('Dr. Andrew Walker'),
            subtitle: Text('Specialist: Neurosurgeon'),
            leading: Icon(Icons.psychology),
          ),
          ListTile(
            title: Text('Dr. Karen Scott'),
            subtitle: Text('Specialist: Neuropsychologist'),
            leading: Icon(Icons.psychology),
          ),
        ],
      ),
    );
  }
}
