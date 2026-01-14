import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/main_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final AuthController authController = Get.find<AuthController>();

  late final TextEditingController _emailController;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: authController.email.value);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() async {
    final res = await authController.register(_usernameController.text, _passwordController.text);

    if (res) {
      Get.snackbar("Success", "Signup successful");
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => const MainPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
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
                      child: Image.asset("assets/images/logo/logo.png", fit: BoxFit.contain),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Title
                Text(
                  "Create account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Constant.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please fill in the details below.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                const SizedBox(height: 32),

                /// Username
                _buildTextField(
                  label: "Username",
                  controller: _usernameController,
                  obscureText: false,
                ),

                const SizedBox(height: 16),

                /// Email (Read-only)
                _buildTextField(
                  label: "Email",
                  controller: _emailController,
                  obscureText: false,
                  readOnly: true,
                  suffixIcon: const Icon(Icons.check, color: Colors.green),
                ),

                const SizedBox(height: 16),

                /// Password
                _buildTextField(
                  label: "Password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

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
                        style: TextStyle(fontWeight: FontWeight.bold, color: Constant.primaryColor),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// Bottom Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: TextStyle(color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () => Get.off(() => const LoginPage()),
                      child: Text(
                        "Sign in",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Constant.primaryColor),
                      ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    bool readOnly = false,
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
        readOnly: readOnly,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },

        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          floatingLabelStyle: TextStyle(color: Constant.primaryColor),

          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
