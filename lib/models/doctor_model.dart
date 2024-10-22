class Doctor {
  String id;
  String name;
  String specialty;
  String phoneNumber;
  String email;

  Doctor({required this.id, required this.name, required this.specialty, required this.phoneNumber, required this.email});

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phoneNumber': phoneNumber,
      'email': email,
    };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
}
