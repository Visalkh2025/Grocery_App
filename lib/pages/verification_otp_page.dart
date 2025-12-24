import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/pages/signup_page.dart';

class VerificationOtpPage extends StatefulWidget {
  const VerificationOtpPage({super.key});

  @override
  State<VerificationOtpPage> createState() => _VerificationOtpPageState();
}

class _VerificationOtpPageState extends State<VerificationOtpPage> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final AuthController authController = Get.find<AuthController>();

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

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (countdown == 0) {
        t.cancel();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void resendCode() {
    startCountdown();
  }

  void onSubmit() async {
    String otp = controllers.map((c) => c.text).join();
    print("OTP: $otp");
    final res = await authController.verifyOtp(otp);
    final success = res.success;
    log("email: ${authController.email.value}");
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res.message ?? "OTP Verified Successfully.")));
      Get.off(() => SignupPage(), transition: Transition.fadeIn);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res.message ?? "Invalid OTP. Please try again.")));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // for (var controller in controllers) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text("Verification OTP", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Enter the 6-digit OTP sent to your email", style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(controllers.length, (index) {
                return SizedBox(
                  width: 50,
                  height: 60,
                  child: TextField(
                    controller: controllers[index],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    // onChanged: (value) {
                    //   if (value.isNotEmpty && index < 6 - 1) {
                    //     FocusScope.of(context).nextFocus();
                    //   } else if (value.isEmpty && index > 0) {
                    //     FocusScope.of(context).previousFocus();
                    //   }
                    // },
                    onChanged: (value) {
                      if (value.length > 1) {
                        // Paste support: take only the first character
                        controllers[index].text = value[0];
                      }

                      if (value.isNotEmpty) {
                        // Move forward if not the last field
                        if (index < controllers.length - 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          // Last field: submit OTP
                          onSubmit();
                        }
                      } else {
                        // User pressed backspace or cleared the field
                        if (index > 0) {
                          FocusScope.of(context).previousFocus();
                          controllers[index - 1].clear(); // clear previous field
                        }
                      }
                    },

                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Constant.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),

            // child: GestureDetector(
            //   onTap: countdown == 0 ? resendCode : null,
            //   child: Text(
            //     countdown == 0 ? "Resend Code" : "Resend Code (${countdown}s)",
            //     style: TextStyle(
            //       color: countdown == 0 ? Constant.primaryColor : Colors.grey,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 18,
            //     ),
            //   ),
            // ),
            child: GestureDetector(
              onTap: () {
                if (countdown == 0) {
                  resendCode();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please wait ${countdown}s before resending."),
                      duration: Duration(seconds: 1),
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
              shape: CircleBorder(),
              onPressed: onSubmit,
              backgroundColor: Constant.primaryColor,
              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
