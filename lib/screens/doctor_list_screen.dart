import 'package:docbook/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
  

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var doctors = snapshot.data!.docs.map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>)).toList();
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return ListTile(
                title: Text(doctor.name),
                subtitle: Text('${doctor.specialty} - ${doctor.phoneNumber}'),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
