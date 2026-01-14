import 'package:flutter/material.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final int _otpLength = 6;
  final TextEditingController _otpController = TextEditingController();
  final AuthController authController = AuthController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.message_rounded, size: 80, color: Colors.blue),
            const SizedBox(height: 32),

            const Text(
              'Enter verification code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text(
              'We have sent a 6-digit code to your phone number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 48),

            /// 🔐 Pinput OTP
            Pinput(
              length: _otpLength,
              controller: _otpController,
              keyboardType: TextInputType.number,
              autofocus: true,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: Colors.blue, width: 2.5),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
              onCompleted: (otp) {
                debugPrint('OTP entered: $otp');
                authController.verifyOtp(otp);
              },
            ),

            const SizedBox(height: 40),

            /// Verify Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _otpController.text.length == _otpLength
                    ? () {
                        final otp = _otpController.text;
                        authController.verifyOtp(otp);

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('OTP Submitted: $otp')));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),

            TextButton(
              onPressed: () {
                // TODO: Resend OTP
              },
              child: const Text("Didn't receive code? Resend", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
