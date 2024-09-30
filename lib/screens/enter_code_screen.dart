import 'package:flutter/material.dart';

class EnterCodeScreen extends StatefulWidget {
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  // Controllers for each digit
  final _digit1Controller = TextEditingController();
  final _digit2Controller = TextEditingController();
  final _digit3Controller = TextEditingController();
  final _digit4Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Validate if all fields are filled with exactly 1 digit
  String? _validateCode() {
    if (_digit1Controller.text.isEmpty ||
        _digit2Controller.text.isEmpty ||
        _digit3Controller.text.isEmpty ||
        _digit4Controller.text.isEmpty) {
      return 'All digits are required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Title
            Text(
              'Enter 4-Digit Code',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 32.0),

            // Instruction Text
            Text(
              'Enter the 4-digit code that you received on your email.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),

            // 4-Digit Code Input Fields in Squares
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDigitTextField(_digit1Controller),
                  _buildDigitTextField(_digit2Controller),
                  _buildDigitTextField(_digit3Controller),
                  _buildDigitTextField(_digit4Controller),
                ],
              ),
            ),
            SizedBox(height: 24.0),

            // Verify Button
            ElevatedButton(
              onPressed: () {
                if (_validateCode() == null) {
                  // Handle code verification logic here
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Code verified successfully.'),
                  ));

                  // Navigate to the ResetPasswordScreen
                  Navigator.pushNamed(context, '/reset-password');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(_validateCode() ?? ''),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'Verify',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a square TextFormField for each digit
  Widget _buildDigitTextField(TextEditingController controller) {
    return Container(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
        ),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // Only allow one character per box
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // Move to next input
          }
        },
      ),
    );
  }
}
