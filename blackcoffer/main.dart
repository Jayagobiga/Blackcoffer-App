import 'package:blackcoffer/videodash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedCountryCode = '+91';
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  void _resendOtp() {
    // Add your OTP resend logic here
    print('OTP resent');
  }

  void _sendOtp() {
    setState(() {
      _otpSent = true;
    });
  }

  void _verifyOtp() {
    // Add your OTP verification logic here
    print('OTP verified');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoDash(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(
                  'assets/viewtube.png', // Replace with your image path
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 10),
                Text(
                  'View Tube',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 60),
                Text(
                  'OTP Verification',
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        items: [
                          DropdownMenuItem<String>(
                            value: '+91',
                            child: Text('+91'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+1',
                            child: Text('+1'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+44',
                            child: Text('+44'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+61',
                            child: Text('+61'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+81',
                            child: Text('+81'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+49',
                            child: Text('+49'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+33',
                            child: Text('+33'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+86',
                            child: Text('+86'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+7',
                            child: Text('+7'),
                          ),
                          DropdownMenuItem<String>(
                            value: '+82',
                            child: Text('+82'),
                          ),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCountryCode = value!;
                          });
                        },
                        value: _selectedCountryCode, // Initial value
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Enter mobile number',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_otpSent)
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _otpSent ? _verifyOtp : _sendOtp,
                  child: Container(
                    width: 170,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueAccent,
                    ),
                    child: Center(
                      child: Text(
                        _otpSent ? 'Verify' : 'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                if (_otpSent)
                  SizedBox(height: 30),
                if (_otpSent)
                  RichText(
                    text: TextSpan(
                      text: 'Did not get OTP? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _resendOtp,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
