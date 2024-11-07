import 'package:docbook/screens/AdminHomePage.dart';
import 'package:docbook/screens/add_page.dart';
import 'package:docbook/screens/admin_bottom_bar.dart';
import 'package:docbook/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditPage extends StatefulWidget {
  final String doctorId;

  const EditPage({super.key, required this.doctorId});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int _selectedIndex = 1;

  File? _image;
  String? _selectedGender;
  String? _selectedCategory;
  String? _existingImageUrl;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _gpServicesController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _feesController =
      TextEditingController(); // Controller for fees

  final List<String> _categories = [
    'Dermatologist',
    'Cardiologist',
    'Pediatrician'
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  Future<void> _fetchDoctorData() async {
    var doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorId)
        .get();
    var data = doc.data();

    if (data != null) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _mobileController.text = data['mobile'] ?? '';
        _emailController.text = data['email'] ?? '';
        _specializationController.text = data['specialist'] ?? '';
        _gpServicesController.text = data['gp_services'] ?? '';
        _professionController.text =
            data['profession'] ?? ''; // Fetching profession
        _feesController.text = data['fees'] ?? ''; // Fetch fees
        _selectedGender = data['gender'];
        _selectedCategory =
            _categories.contains(data['category']) ? data['category'] : null;
        _existingImageUrl = data['image_url'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (_existingImageUrl != null) {
        try {
          await FirebaseStorage.instance
              .refFromURL(_existingImageUrl!)
              .delete();
        } catch (e) {
          if (e is FirebaseException && e.code == 'object-not-found') {
            print('No existing image found at the reference.');
          } else {
            print('Error deleting old image: $e');
          }
        }
      }
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateDoctorData() async {
    String? imageUrl;
    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('doctor_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_image!);
      imageUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorId)
        .update({
      'name': _nameController.text,
      'mobile': _mobileController.text,
      'email': _emailController.text,
      'specialist': _specializationController.text,
      'gp_services': _gpServicesController.text,
      'gender': _selectedGender,
      'category': _selectedCategory,
      'profession': _professionController.text, // Update profession
      'fees': _feesController.text, // Update doctor fees
      'image_url': imageUrl ?? _existingImageUrl,
    });
    Navigator.pop(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Doctor'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Doctor's Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: "Specialist",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _gpServicesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "GP Services",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: _genders
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Profession Text Field
              TextField(
                controller: _professionController,
                decoration: const InputDecoration(
                  labelText: "Profession",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Doctor's Fees Text Field
              TextField(
                controller: _feesController,
                decoration: const InputDecoration(
                  labelText: "Doctor's Fees",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Display the selected image if available; otherwise show existing image URL
              _image != null
                  ? Column(
                      children: [
                        Image.file(
                          _image!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        TextButton(
                          onPressed: _pickImage,
                          child: const Text('Change Image'),
                        )
                      ],
                    )
                  : _existingImageUrl != null
                      ? Column(
                          children: [
                            Image.network(
                              _existingImageUrl!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            TextButton(
                              onPressed: _pickImage,
                              child: const Text('Change Image'),
                            )
                          ],
                        )
                      : ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Add Doctor Image'),
                        ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateDoctorData,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdminBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
