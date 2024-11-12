import 'package:docbook/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoAlertDialog (optional)

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  String? doctorEmail;
  bool isDoctor = false;
  late Stream<DocumentSnapshot> userDocStream;

  @override
  void initState() {
    super.initState();
    _checkUserRoleAndFetchDoctorEmail();
  }

  // Step 1: Check if the user is a doctor and fetch doctor email accordingly
  Future<void> _checkUserRoleAndFetchDoctorEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in as a doctor.')),
      );
      return;
    }

    // Listen to changes in the user's document in real-time
    userDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();

    userDocStream.listen((userDoc) {
      if (userDoc.exists) {
        final data = userDoc.data()
            as Map<String, dynamic>?; // Safely cast document data to Map
        isDoctor = data != null && data['role'] == 'doctor';

        if (isDoctor) {
          _fetchDoctorEmail(user.email);
        } else {
          setState(() {
            doctorEmail = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access restricted to doctors only.')),
          );
        }
      }
    });
  }

  // Step 2: Fetch doctor email based on the user's email
  Future<void> _fetchDoctorEmail(String? email) async {
    if (email == null) return;

    try {
      final doctorSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('email', isEqualTo: email)
          .get();

      if (doctorSnapshot.docs.isNotEmpty) {
        setState(() {
          doctorEmail =
              doctorSnapshot.docs.first['email']; // Store doctor's email
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doctor profile not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching doctor profile: $e')),
      );
    }
  }

  // Step 3: Logout function
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Confirm logout before actually signing out
              showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to log out?"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text("Logout"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _logout(); // Call logout method
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: !isDoctor
          ? const Center(child: Text('Access restricted to doctors only.'))
          : doctorEmail == null
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .where('doctoremail',
                          isEqualTo:
                              doctorEmail) // Filter appointments by doctor email
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final appointments = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        var appointment =
                            appointments[index].data() as Map<String, dynamic>;

                        return ListTile(
                          title: Text('Patient: ${appointment['patientName']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status: ${appointment['status']}'),
                              Text(
                                  'Date: ${appointment['appointmentDate'].toDate().toString()}'),
                              Text(
                                  'Doctor Email: ${appointment['doctoremail']}'),
                            ],
                          ),
                          trailing: DropdownButton<String>(
                            value: appointment['status'],
                            items: <String>['pending', 'confirmed', 'cancelled']
                                .map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                FirebaseFirestore.instance
                                    .collection('appointments')
                                    .doc(appointments[index].id)
                                    .update({'status': newStatus});
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
