import 'videodash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OtpVerifyPage extends StatelessWidget {
  const OtpVerifyPage({Key? key});

  void _resendOtp() {
    // Add your OTP resend logic here
    print('OTP resent');
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
                  height: 200,
                ),
                SizedBox(height: 10),
                Text(
                  'View Tube',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOtpTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      nextFocusNode: FocusNode(),
                    ),
                    SizedBox(width: 10),
                    _buildOtpTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      nextFocusNode: FocusNode(),
                    ),
                    SizedBox(width: 10),
                    _buildOtpTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      nextFocusNode: FocusNode(),
                    ),
                    SizedBox(width: 10),
                    _buildOtpTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      nextFocusNode: FocusNode(),
                    ),
                  ],
                ),
                SizedBox(height: 30),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoDash(),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueAccent,
                    ),
                    child: Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0, top: 30),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode nextFocusNode,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          onChanged: (String value) {
            if (value.isNotEmpty) {
              focusNode.unfocus(); // Unfocus current field
              nextFocusNode.requestFocus(); // Move focus to next field
            }
          },
        ),
      ),
    );
  }
}
