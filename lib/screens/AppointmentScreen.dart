import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'appointments_page.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String patientMobile;
  final String patientEmail;
  final String doctorId;
  final String doctorFees;
  final String doctoremail;

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
    required this.doctorFees,
    required this.doctoremail,
  });

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _selectedDay = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  late Razorpay _razorpay;

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
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful: ${response.paymentId}')),
      );
      _saveAppointment();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppointmentsPage()),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.message}')),
        );
      }
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet: ${response.walletName}')),
      );
    }
  }

  Future<void> _startPayment() async {
    int amount;
    try {
      amount = int.parse(widget.doctorFees) * 100;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid doctor fee amount')),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_FNY2BJxFQpkE2l',
      'amount': amount,
      'name': widget.doctorName,
      'description': 'Appointment with ${widget.doctorName}',
      'prefill': {
        'contact': widget.patientMobile,
        'email': widget.patientEmail,
      },
      'theme': {
        'color': '#F37254',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening payment gateway: $e')),
        );
      }
    }
  }

  Future<void> _saveAppointment() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please log in to book an appointment.')),
        );
      }
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
        "status": "pending", // Changed status to "pending"
        "doctorFees": widget.doctorFees,
        "createdAt": Timestamp.now(),
        "doctoremail": widget.doctoremail,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment successfully created!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save appointment: $e')),
        );
      }
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
              onPressed: _startPayment,
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
