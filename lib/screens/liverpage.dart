import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class LiverPage extends StatelessWidget {
  const LiverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liver Doctors'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Dr. Michael Johnson'),
            subtitle: Text('Specialist: Hepatologist'),
            leading: Icon(Icons.local_drink),
          ),
          ListTile(
            title: Text('Dr. Olivia Davis'),
            subtitle: Text('Specialist: Liver Transplant Surgeon'),
            leading: Icon(Icons.local_drink),
          ),
          ListTile(
            title: Text('Dr. Patrick White'),
            subtitle: Text('Specialist: Gastroenterologist'),
            leading: Icon(Icons.local_drink),
          ),
        ],
      ),
    );
  }
}
