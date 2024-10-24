import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:docbook/screens/admin_bottom_bar.dart';
import 'package:docbook/screens/AdminHomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For file handling

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int _selectedIndex = 1;
  File? _image;
  String? _selectedGender;
  String? _selectedCategory;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _specialistController = TextEditingController();
  final _gpServicesController = TextEditingController();
  String? _selectedProfession;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Add Firebase Storage

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      Reference storageReference = _storage.ref().child('doctor_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Return the download URL
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  // Method to submit form data to Firebase Firestore
  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _specialistController.text.isEmpty ||
        _gpServicesController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedProfession == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    try {
      String? imageUrl;

      // Upload the image if it exists
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
        if (imageUrl == null) {
          // If image upload fails, show an error message and stop the form submission
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
          return;
        }
      }

      // Save doctor information to Firestore
      await _firestore.collection('doctors').add({
        'name': _nameController.text,
        'mobile': _mobileController.text,
        'email': _emailController.text,
        'specialist': _specialistController.text,
        'gp_services': _gpServicesController.text,
        'category': _selectedCategory,
        'profession': _selectedProfession,
        'gender': _selectedGender,
        'image_url': imageUrl, // Include image URL in Firestore document
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor added successfully!')),
      );

      // Clear form fields after submission
      _nameController.clear();
      _mobileController.clear();
      _emailController.clear();
      _specialistController.clear();
      _gpServicesController.clear();
      setState(() {
        _image = null;
        _selectedGender = null;
        _selectedCategory = null;
        _selectedProfession = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Doctor'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double fieldWidth = screenWidth > 600 ? 600 : screenWidth * 0.9;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Doctor',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Doctor's Name
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Doctor's Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mobile Number
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          labelText: "Mobile Number",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Specialist
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _specialistController,
                        decoration: const InputDecoration(
                          labelText: "Specialist",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // General Practitioner (GP) Services
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _gpServicesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "General Practitioner (GP) Services",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category Dropdown
                    SizedBox(
                      width: fieldWidth,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          'General Medicine',
                          'Pediatrics',
                          'Gynecology',
                          'Dermatology',
                          'Cardiology',
                          'Other',
                        ]
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
                    ),
                    const SizedBox(height: 20),

                    // Profession Dropdown
                    SizedBox(
                      width: fieldWidth,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Profession',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Degree', 'Diploma', 'Other']
                            .map((profession) => DropdownMenuItem<String>(
                                  value: profession,
                                  child: Text(profession),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProfession = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Doctor's Image Section
                    _image == null
                        ? ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Add Doctor Image'),
                          )
                        : Column(
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
                              ),
                            ],
                          ),

                    const SizedBox(height: 20),

                    // Gender Dropdown
                    SizedBox(
                      width: fieldWidth,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Male',
                            child: Text('Male'),
                          ),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: fieldWidth,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Doctor',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}
