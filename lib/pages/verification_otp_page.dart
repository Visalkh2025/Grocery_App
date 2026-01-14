import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/pages/signup_page.dart';
import 'package:pinput/pinput.dart';

class VerificationOtpPage extends StatefulWidget {
  const VerificationOtpPage({super.key});

  @override
  State<VerificationOtpPage> createState() => _VerificationOtpPageState();
}

class _VerificationOtpPageState extends State<VerificationOtpPage> {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController otpController = TextEditingController();

  int countdown = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    countdown = 60;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown == 0) {
        t.cancel();
      } else {
        setState(() => countdown--);
      }
    });
  }

  void resendCode() {
    startCountdown();
    // TODO: call resend OTP API here
  }

  Future<void> onSubmit([String? otp]) async {
    final enteredOtp = otp ?? otpController.text;

    if (enteredOtp.length != 6) return;

    log("OTP: $enteredOtp");
    final success = await authController.verifyOtp(enteredOtp);
    log("email: ${authController.email.value}");

    if (success) {
      Get.off(() => SignupPage(), transition: Transition.fadeIn);
    } else {
      Get.snackbar(
        "Invalid OTP",
        "Please try again",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Text(
              "Verification OTP",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text("Enter the 6-digit OTP sent to your email", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 30),

            /// 🔐 Pinput
            Center(
              child: Pinput(
                length: 6,
                controller: otpController,
                autofocus: true,
                keyboardType: TextInputType.number,
                defaultPinTheme: pinTheme,
                focusedPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    border: Border.all(color: Constant.primaryColor, width: 2),
                  ),
                ),
                errorPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                ),
                onCompleted: onSubmit, // auto submit
              ),
            ),
          ],
        ),
      ),

      /// Bottom actions
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {
                if (countdown == 0) {
                  resendCode();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please wait ${countdown}s before resending."),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Text(
                countdown == 0 ? "Resend Code" : "Resend Code (${countdown}s)",
                style: TextStyle(
                  color: countdown == 0 ? Constant.primaryColor : Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () => onSubmit(),
              backgroundColor: Constant.primaryColor,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
