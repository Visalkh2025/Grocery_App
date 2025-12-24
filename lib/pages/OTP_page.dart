import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/controller/auth_controller.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final int _otpLength = 6;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late List<String> _otpValues;
  final AuthController authController = AuthController();

  @override
  // void initState() {
  //   super.initState();
  //   _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  //   _controllers = List.generate(_otpLength, (_) => TextEditingController());
  //   _otpValues = List.filled(_otpLength, '');

  //   // Listen for clipboard paste
  //   _checkClipboard();
  // }

  // Future<void> _checkClipboard() async {
  //   final data = await Clipboard.getData('text/plain');
  //   final text = data?.text?.trim() ?? '';
  //   if (text.length == _otpLength && text.contains(RegExp(r'^[0-9]{6}$'))) {
  //     for (int i = 0; i < _otpLength; i++) {
  //       _controllers[i].text = text[i];
  //       _otpValues[i] = text[i];
  //     }
  //     setState(() {});
  //     _focusNodes.last.requestFocus();
  //   }
  // }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Pasted multiple characters
      final pasted = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (pasted.length >= _otpLength) {
        final otp = pasted.substring(0, _otpLength);
        for (int i = 0; i < _otpLength; i++) {
          _controllers[i].text = otp[i];
          _otpValues[i] = otp[i];
        }
        _focusNodes.last.requestFocus();
      }
    } else if (value.isNotEmpty) {
      _otpValues[index] = value;
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      _otpValues[index] = '';
    }
    setState(() {});

    // Optional: Check if OTP is complete
    if (_otpValues.every((e) => e.isNotEmpty)) {
      final enteredOtp = _otpValues.join();
      debugPrint('OTP entered: $enteredOtp');
      // TODO: Verify OTP here
    }
  }

  void _onKey(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
        _otpValues[index - 1] = '';
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 56,
      height: 56,
      child: RawKeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKey: (event) => _onKey(event, index),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          onChanged: (value) => _onChanged(value, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            // 6 OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_otpLength, (i) => _buildOtpBox(i)),
            ),

            const SizedBox(height: 40),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _otpValues.every((e) => e.isNotEmpty)
                    ? () {
                        final otp = _otpValues.join();
                        authController.verifyOtp(otp);

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('OTP Submitted: $otp')));
                        // TODO: Submit OTP
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
