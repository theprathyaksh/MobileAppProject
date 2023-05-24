import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationPage extends StatelessWidget {
  final String verificationId;
  final TextEditingController _otpController = TextEditingController();

  OTPVerificationPage(this.verificationId);

  Future<void> _signInWithPhoneNumber(BuildContext context, String otp) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Handle the logged in user (navigate to next screen, etc.)
      print('Verification successful: ${userCredential.user?.uid}');
    } catch (e) {
      // Handle verification failure
      print('Verification failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String otp = _otpController.text.trim();
                _signInWithPhoneNumber(context, otp);
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
