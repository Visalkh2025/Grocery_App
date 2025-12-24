import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/pages/signup_page.dart';
import 'package:grocery_app/utils/snackbar_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String logo = "assets/icons/app_icon_color.svg";
  bool _obscurePassword = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final authController = Get.find<AuthController>();
  void login() async {
    final res = await authController.login(email.text, password.text);
    if (res.success) {
      SnackbarHelper.showSuccess("Success", res.message ?? "Login successful");
      // delay to show snackbar
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => MainPage());
      log("Login successful");
    } else {
      SnackbarHelper.showError("Error", res.message ?? "Login failed");
      log("Login faileddd");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(child: SvgPicture.asset(logo, width: 50)),
                SizedBox(height: size.width * 0.07),
                Text(
                  "Login Page",
                  style: TextStyle(fontSize: size.width * 0.08, fontWeight: FontWeight.bold),
                ),

                Text(
                  "Enter your credential to continue",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: size.width * 0.07),
                Text("Email"),

                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Enter email",
                    suffixIcon: Icon(Icons.check, color: Colors.green),
                  ),
                ),
                SizedBox(height: size.width * 0.07),
                Text("Password"),

                TextField(
                  controller: password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.04),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text("Forgot password"),
                  ),
                ),
                SizedBox(height: size.width * 0.07),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff53B176),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: authController.isLoading.value
                        ? CircularProgressIndicator()
                        : Text("Sign In", style: TextStyle(color: Colors.white)),
                    onPressed: login,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an accound?"),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text("Register", style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
