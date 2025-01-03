import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:backoffice52switch/modules/authentication/auth_service.dart';
import 'package:backoffice52switch/utils/constants.dart';
import 'package:backoffice52switch/modules/shared/navigation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  String _verificationId = '';
  bool _isOtpSent = false;
  String _authStatusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkStoredFirebaseUid();
  }

  Future<void> _checkStoredFirebaseUid() async {
    String? uid = await _storage.read(key: 'firebaseUid');
    String? phone = await _storage.read(key: 'phoneNumber');
    if (uid != null && phone != null) {
      // Query backend to validate Firebase UID and retrieve objectId
      print(uid);
      print(phone);
      final success = await _validateUidAndFetchObjectId(uid, phone);
      if (success)return;
      // Clear storage if validation fails
      await _storage.deleteAll();
      setState(() {
        _authStatusMessage = 'Validation failed, please log in again.';
      });
    }
  }


  Future<bool> _validateUidAndFetchObjectId(String uid, String phone) async {
    final AuthService authService = AuthService();
    try {
      final result = await authService.validateUidAndPhone(uid, phone);

      if (result != null && result['objectId'] != null) {
        Constants.objectId = result['objectId'];
        //Constants.employeeName = result['employeeName'];
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Navigation()),
          );
        }

        return true;
      }
    } catch (e) {
      setState(() {
        _authStatusMessage = 'Validation error: $e';
      });
    }
    return false;
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      _verificationId = '';
      _isOtpSent = false;
      _otpController.clear();
      _authStatusMessage = '';
    });

    String formattedPhone = phoneNumber.startsWith('0')
        ? '+82${phoneNumber.substring(1)}'
        : phoneNumber;

    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await _fetchAndStoreUid(phoneNumber);

      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _fetchAndStoreUid(String phoneNumber) async {
    final User? user = _auth.currentUser;
    if (user != null) {

      await _storage.write(key: 'firebaseUid', value: user.uid);
      await _storage.write(key: 'phoneNumber', value: phoneNumber);

      // Query backend for objectId
      final success = await _validateUidAndFetchObjectId(user.uid, phoneNumber);

      if (!success) {
        setState(() {
          _authStatusMessage = 'Validation failed due to a delay. Retrying...';
        });
        Future.delayed(Duration(seconds: 2), () async {
          final retrySuccess =
            await _validateUidAndFetchObjectId(user.uid, phoneNumber);
          if (!retrySuccess) {
            setState(() {
              _authStatusMessage = 'Validation failed. Please log in again.';
            });
            await _storage.deleteAll();
          }
        });
      }

    }
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isOtpSent)
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number (e.g., 01012345678)',
                  errorText: _phoneController.text.isNotEmpty &&
                      !_phoneController.text.startsWith('0')
                      ? 'Phone number must start with 0'
                      : null,
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) => setState(() {}),
              ),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'OTP'),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            if (!_isOtpSent)
              ElevatedButton(
                onPressed: () {
                  if (_phoneController.text.startsWith('0') &&
                      _phoneController.text.length > 1) {
                    _verifyPhoneNumber(_phoneController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Enter a valid phone number starting with 0')),
                    );
                  }
                },
                child: Text('Send OTP'),
              ),
            if (_isOtpSent)
              ElevatedButton(
                onPressed: () async {
                  final smsCode = _otpController.text;
                  final credential = PhoneAuthProvider.credential(
                      verificationId: _verificationId, smsCode: smsCode);
                  try {
                    await _auth.signInWithCredential(credential);
                    await _fetchAndStoreUid(_phoneController.text);
                  } catch (e) {
                    setState(() {
                      _authStatusMessage = 'Invalid OTP';
                    });
                  }
                },
                child: Text('Verify OTP'),
              ),
            if (_authStatusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _authStatusMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_isOtpSent)
              TextButton(
                onPressed: () async {
                  await _storage.deleteAll();
                  setState(() {
                    _isOtpSent = false;
                    _phoneController.clear();
                    _otpController.clear();
                    _authStatusMessage = '';
                  });
                },
                child: Text('Restart Login Process'),
              ),
          ],
        ),
      ),
    );
  }
}
