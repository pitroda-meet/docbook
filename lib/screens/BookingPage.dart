import 'package:flutter/material.dart';
import 'AppointmentScreen.dart';
import 'package:docbook/screens/bottom_bar_widget.dart';

class BookingPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String imagePath;
  final String doctorFees;
  final String doctoremail;

  const BookingPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.imagePath,
    required this.doctorFees,
    required this.doctoremail,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Book Appointment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.imagePath),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.doctorName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(widget.specialization,
                            style: const TextStyle(color: Colors.grey)),
                        Text(widget.doctorFees,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Patient\'s Name'),
              TextFormField(
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Age'),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your age' : null,
                decoration: const InputDecoration(
                  hintText: 'Enter Age',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Gender'),
              Row(
                children: [
                  _buildGenderRadio('Male'),
                  _buildGenderRadio('Female'),
                  _buildGenderRadio('Others'),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Mobile Number'),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your mobile number' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Email'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentScreen(
                          doctorId: widget.doctorId,
                          doctoremail: widget.doctoremail,
                          doctorFees: widget.doctorFees,
                          doctorName: widget.doctorName,
                          specialization: widget.specialization,
                          patientName: _nameController.text,
                          patientAge: _ageController.text,
                          patientGender: _selectedGender,
                          patientMobile: _mobileController.text,
                          patientEmail: _emailController.text,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: 0,
        onTabTapped: (int value) {},
      ),
    );
  }

  Widget _buildGenderRadio(String gender) {
    return Row(
      children: [
        Radio(
          value: gender,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value.toString();
            });
          },
        ),
        Text(gender),
      ],
    );
  }
}
