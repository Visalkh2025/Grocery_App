import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/pages/email_page.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/pages/signup_page.dart';
import 'package:grocery_app/service/google_signin_service.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:grocery_app/service/google_signin_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());
  final GoogleSigninService _googleSignInService = GoogleSigninService();

  void login() async {
    final res = await authController.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (res['success'] == true) {
      Get.snackbar("Success", res['message'] ?? "Login successful");
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => const MainPage());
      log("Login successful");
    } else {
      Get.snackbar("Error", res['message'] ?? "Login failed");
    }
  }

  void _signInGoogle() async {
    await _googleSignInService.signOut();
    GoogleSignInAccount? user = await _googleSignInService.signInWithGoogle();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    log("IDTOKen: ${auth?.idToken}");
    // authController.loginGoogle(auth?.idToken?.toString() ?? '');
    final res = await authController.loginGoogle(auth?.idToken?.toString() ?? "");
    if (res['success'] == true) {
      log("Token saved: ${res['token']}");
      log("User info: ${res['user'] ?? ""}");
      Get.snackbar("success", res['message'] ?? "Login successful");
      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.offAll(() => MainPage());
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Constant.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset(
                          "assets/images/logo/logo.png",
                          fit: BoxFit.contain, // Keeps the logo proportional
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Title
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Constant.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please enter your details.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 32),

                  /// Email
                  _buildTextField(label: "Email", controller: emailController, obscureText: false),

                  const SizedBox(height: 16),

                  /// Password
                  _buildTextField(
                    label: "Password",
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Remember me & Forgot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (v) => setState(() => _rememberMe = v!),
                            activeColor: Constant.primaryColor,
                          ),

                          Text("Remember me", style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constant.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authController.isLoading.value ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: authController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _signInGoogle,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.g_mobiledata, size: 32, color: Colors.blue[700]),
                          Image.asset("assets/images/google.jpg", width: 30, height: 30),
                          const SizedBox(width: 8),
                          const Text(
                            "Sign in with Google",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Bottom text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                      GestureDetector(
                        onTap: () => Get.to(() => const EmailPage()),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constant.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(color: Constant.primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
