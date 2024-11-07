import 'package:docbook/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:docbook/screens/admin_bottom_bar.dart';
import 'package:docbook/screens/AdminHomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final _feesController = TextEditingController(); // Added Fees Controller
  String? _selectedProfession;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        print('Picked Image Path: ${pickedFile.path}');
      });
    } else {
      print('No image selected.');
    }
  }

  // Method to upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference =
          _storage.ref().child('doctor_images/$fileName');

      print('Attempting to upload to path: doctor_images/$fileName');

      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {
        print('Upload complete');
      });

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded successfully. Download URL: $downloadUrl');
      return downloadUrl; // Return the download URL
    } catch (e) {
      print('Error uploading image: $e');
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
        _feesController.text.isEmpty || // Check for fees field
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
      } else {
        print('No image selected for upload.');
      }

      // Save doctor information to Firestore
      await _firestore.collection('doctors').add({
        'name': _nameController.text,
        'mobile': _mobileController.text,
        'email': _emailController.text,
        'specialist': _specialistController.text,
        'gp_services': _gpServicesController.text,
        'fees': _feesController.text, // Add fees to Firestore
        'category': _selectedCategory,
        'profession': _selectedProfession,
        'gender': _selectedGender,
        'image_url': imageUrl,
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
      _feesController.clear(); // Clear the fees field
      setState(() {
        _image = null;
        _selectedGender = null;
        _selectedCategory = null;
        _selectedProfession = null;
      });
    } catch (e) {
      print('Error saving doctor data to Firestore: $e');
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPage()),
      );
    } else if (index == 2) {
      // New "Users" Page navigation
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserPage()),
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

                    // Doctor's Fees (New Field)
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _feesController,
                        decoration: const InputDecoration(
                          labelText: "Doctor's Fees",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
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
                        items: ['Dermatologist', 'Cardiologist', 'Pediatrician']
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
                        items: ['Doctor', 'Nurse', 'Technician']
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

                    // Image Picker
                    _image == null
                        ? ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Pick Image'),
                          )
                        : Column(
                            children: [
                              Image.file(
                                _image!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              ElevatedButton(
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
                        items: ['Male', 'Female', 'Other']
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
      bottomNavigationBar: AdminBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
