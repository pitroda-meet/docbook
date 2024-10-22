import 'package:docbook/screens/bottom_bar_widget.dart';
import 'package:docbook/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const AppointmentScreen({
    super.key, 
    required this.doctorName, 
    required this.specialization, 
    required this.selectedDate, 
    required this.selectedTime,
  });

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late DateTime _selectedDay;
  late TimeOfDay _selectedTime;
  int _selectedReminder = 25;
  final int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDate;
    _selectedTime = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildCalendar(),
              SizedBox(height: screenHeight * 0.02),
              _buildAvailableTimes(),
              SizedBox(height: screenHeight * 0.02),
              _buildReminderOptions(),
              SizedBox(height: screenHeight * 0.02),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarWidget(currentIndex: 1, onTabTapped: (int value) {  },),
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
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.teal,
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildAvailableTimes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildTimeOptions(),
        ),
      ],
    );
  }

  List<Widget> _buildTimeOptions() {
    final times = [
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 12, minute: 0),
      const TimeOfDay(hour: 14, minute: 0),
      const TimeOfDay(hour: 15, minute: 0),
      const TimeOfDay(hour: 16, minute: 0),
    ];

    return times.map((time) {
      final isSelected = time == _selectedTime;
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedTime = time;
          });
        },
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal : Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.teal : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              time.format(context),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildReminderOptions() {
    final reminders = [10, 25, 30, 35, 40];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reminder Me Before', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: reminders.map((minutes) {
            final isSelected = minutes == _selectedReminder;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedReminder = minutes;
                });
              },
              child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal : Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$minutes Min',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to AppointmentDetailScreen when Confirm is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppointmentDetailScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(150, 48),
        ),
        child: const Text('Confirm', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Appointment confirmed! Your details will appear here.',
          style: TextStyle(fontSize: 18, color: Colors.teal),
        ),
      ),
    );
  }
}
