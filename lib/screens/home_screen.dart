import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_detail_page.dart';
import 'category_page.dart';
import 'package:docbook/screens/profile_screen.dart';
import 'package:docbook/screens/bottom_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await FirebaseAuth.instance.signOut();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Find Your Doctor',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Colors.teal,
          elevation: 0,
          toolbarHeight: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.teal),
                ),
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search.....',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),

              // Category Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryIcon(
                      Icons.local_hospital, Colors.blue, 'Dentist', context),
                  _buildCategoryIcon(
                      Icons.favorite, Colors.green, 'Cardiology', context),
                  _buildCategoryIcon(
                      Icons.visibility, Colors.orange, 'Eye', context),
                  _buildCategoryIcon(
                      Icons.pregnant_woman, Colors.red, 'Gynae', context),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('doctors')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());

                    final doctors = snapshot.data!.docs;

                    final filteredDoctors = doctors.where((doctor) {
                      final doctorData = doctor.data() as Map<String, dynamic>;
                      final doctorName =
                          doctorData['name']?.toLowerCase() ?? '';
                      final doctorSpecialization =
                          doctorData['specialist']?.toLowerCase() ?? '';
                      return doctorName.contains(_searchQuery.toLowerCase()) ||
                          doctorSpecialization
                              .contains(_searchQuery.toLowerCase());
                    }).toList();

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctorData = filteredDoctors[index].data()
                            as Map<String, dynamic>;
                        return _buildDoctorCard(
                          doctorData['name'] ?? 'Unknown',
                          doctorData['specialist'] ?? 'Specialist',
                          doctorData['image_url'] ?? '',
                          context,
                          doctorData,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomBarWidget(
          currentIndex: 0,
          onTabTapped: (int value) {},
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(
      IconData iconData, Color color, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryPage(categoryName: label)),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(iconData, size: 30, color: color),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(String name, String specialization, String imageUrl,
      BuildContext context, Map<String, dynamic> doctorData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailPage(
              doctorData: doctorData,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    specialization,
                    style: const TextStyle(color: Colors.teal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
