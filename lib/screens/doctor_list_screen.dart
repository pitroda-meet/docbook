class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String phoneNumber;
  final String email;
  final String imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phoneNumber,
    required this.email,
    required this.imageUrl, // Ensure imageUrl is a required field
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phoneNumber': phoneNumber,
      'email': email,
      'imageUrl': imageUrl, // Ensure this is included
    };
  }

  // Add a fromJson constructor if necessary
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      imageUrl: json['imageUrl'] ?? '', // Provide a default if null
    );
  }
}
