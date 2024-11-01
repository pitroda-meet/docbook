import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String patientMobile;
  final String patientEmail;
  final String doctorId;

  const AppointmentScreen({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientMobile,
    required this.patientEmail,
    required this.doctorId,
  });

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _selectedDay = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  late Razorpay _razorpay; // Razorpay instance

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear all listeners on dispose
    super.dispose();
  }

  // Payment success handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful: ${response.paymentId}')),
    );
    _saveAppointment(); // Save appointment after successful payment
  }

  // Payment error handler
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  // External wallet handler
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  Future<void> _startPayment() async {
    var options = {
      'key': 'rzp_test_FNY2BJxFQpkE2l', // Replace with your Razorpay key
      'amount': 50000, // Amount in the smallest currency unit (500 INR)
      'name': widget.doctorName,
      'description': 'Appointment with ${widget.doctorName}',
      'prefill': {
        'contact': widget.patientMobile,
        'email': widget.patientEmail,
      },
      'theme': {
        'color': '#F37254', // Optional: Custom theme color
      },
    };

    try {
      _razorpay.open(options); // Open Razorpay payment gateway
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening payment gateway: $e')),
      );
    }
  }

  Future<void> _saveAppointment() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to book an appointment.')),
      );
      return;
    }

    try {
      final appointmentTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await FirebaseFirestore.instance.collection('appointments').add({
        "userId": user.uid,
        "doctorId": widget.doctorId,
        "doctorName": widget.doctorName,
        "specialization": widget.specialization,
        "patientName": widget.patientName,
        "patientAge": widget.patientAge,
        "patientGender": widget.patientGender,
        "patientMobile": widget.patientMobile,
        "patientEmail": widget.patientEmail,
        "appointmentDate": _selectedDay,
        "appointmentTime": appointmentTime,
        "status": "confirmed",
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment successfully created!')),
      );

      Navigator.pop(context); // Navigate back after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendar(),
            _buildAvailableTimes(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startPayment, // Trigger payment process
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
        });
      },
      headerStyle: const HeaderStyle(titleCentered: true),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.tealAccent),
        selectedDecoration: BoxDecoration(color: Colors.teal),
      ),
    );
  }

  Widget _buildAvailableTimes() {
    final times = [
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 12, minute: 0),
      const TimeOfDay(hour: 14, minute: 0),
      const TimeOfDay(hour: 15, minute: 0),
      const TimeOfDay(hour: 16, minute: 0),
    ];

    return Wrap(
      spacing: 8,
      children: times
          .map((time) => GestureDetector(
                onTap: () => setState(() {
                  _selectedTime = time;
                }),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _selectedTime == time ? Colors.teal : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(time.format(context)),
                ),
              ))
          .toList(),
    );
  }
}
