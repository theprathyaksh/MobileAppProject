import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'OTP_verification.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String phoneNumber = _phoneNumberController.text.trim();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic verification for some devices
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        // Handle the logged in user (navigate to next screen, etc.)
        print('Automatic verification successful: ${userCredential.user?.uid}');
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print('Verification failed: ${e.code}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Navigate to OTP verification screen and pass verificationId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
        print('Code auto retrieval timeout: $verificationId');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Number Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _verifyPhoneNumber(context),
              child: Text('Get OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
