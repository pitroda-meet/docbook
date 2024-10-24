import 'package:docbook/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _addDoctor() async {
    if (_formKey.currentState!.validate()) {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      Doctor newDoctor = Doctor(
        id: id,
        name: _nameController.text,
        specialty: _specialtyController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
      );
      await FirebaseFirestore.instance.collection('doctors').doc(id).set(newDoctor.toJson());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Doctor added successfully!')));
      _nameController.clear();
      _specialtyController.clear();
      _phoneNumberController.clear();
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Doctor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name'), validator: (value) => value!.isEmpty ? 'Enter doctor name' : null),
              TextFormField(controller: _specialtyController, decoration: const InputDecoration(labelText: 'Specialty'), validator: (value) => value!.isEmpty ? 'Enter doctor specialty' : null),
              TextFormField(controller: _phoneNumberController, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone, validator: (value) => value!.isEmpty ? 'Enter phone number' : null),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (value) => value!.isEmpty ? 'Enter email' : null),
              const SizedBox(height: 20),
            
              ElevatedButton(onPressed: _addDoctor, child: const Text('Add Doctor')),
            ],
          ),
        ),
      ),
    );
  }
}
