import 'package:flutter/material.dart';
import 'package:docbook/screens/admin_bottom_bar.dart';
import 'package:docbook/screens/AdminHomePage.dart';
import 'package:docbook/screens/add_page.dart';
import 'package:image_picker/image_picker.dart'; // For image picker
import 'dart:io'; // For handling file system

class EditPage extends StatefulWidget {
  final String doctorName;
  final String specialization;

  const EditPage({
    super.key,
    required this.doctorName,
    required this.specialization,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int _selectedIndex = 0;
  File? _image; // To store the selected image
  String? _selectedGender; // To hold the selected gender
  String? _selectedCategory; // To hold the selected category

  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _gpServicesController = TextEditingController();

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
  void initState() {
    super.initState();

    // Initialize controllers with existing values
    _nameController.text = widget.doctorName;
    _specializationController.text = widget.specialization;
  }

  @override
  void dispose() {
    // Dispose controllers when done
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _specializationController.dispose();
    _gpServicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Doctor'),
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
                      'Edit Doctor Details',
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
                        controller: _specializationController,
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
                        maxLines: 3, // Multi-line input
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
                              )
                            ],
                          ),
                    const SizedBox(height: 20),

                    // Gender Radio Buttons
                    const Text(
                      'Gender',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                        height: 10), // Add some space before the radio buttons
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center them horizontally
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Male',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            const Text('Male'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Female',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            const Text('Female'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Other',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            const Text('Other'),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Update Button
                    ElevatedButton(
                      onPressed: () {
                        // Handle update logic here
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(fieldWidth, 50),
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Update'),
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
