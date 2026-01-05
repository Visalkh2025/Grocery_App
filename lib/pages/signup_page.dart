import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/service/storage/token_storage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final String logo = "assets/icons/app_icon_color.svg";
  bool _obscurePassword = true;
  final AuthController authController = Get.find<AuthController>();
  late final TextEditingController _emailController;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TokenStorage _tokenStorage = TokenStorage();

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
    final username = _usernameController.text;
    final password = _passwordController.text;
    final res = await authController.register(username, password);
    final success = res.success;
    if (success) {
      await _tokenStorage.setToken(res.token!);
      Get.snackbar("Success", "Signup successful");
      log("User data: ${res.user}");
      log("Signup successful, ${res.token}");
      Get.offAll(() => MainPage());
    } else {
      Get.snackbar("Error", res.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: SvgPicture.asset(logo, width: 50)),
              SizedBox(height: size.width * 0.07),
              Text(
                "Sign Up",
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
              Text(
                "Username",
                style: TextStyle(color: Colors.grey.shade700, fontSize: size.width * 0.04),
              ),

              TextField(
                controller: _usernameController,
                decoration: InputDecoration(hintText: "Enter username"),
              ),
              SizedBox(height: size.width * 0.07),
              Text("Email"),

              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Enter email",
                  suffixIcon: Icon(Icons.check, color: Colors.green),
                ),
              ),
              SizedBox(height: size.width * 0.07),
              Text("Password"),

              TextField(
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
              SizedBox(height: size.width * 0.07),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'By continuing you agree to our',
                      style: TextStyle(color: Colors.black, fontSize: size.width * 0.04),
                    ),
                    TextSpan(
                      text: 'Terms of Services',
                      style: TextStyle(color: Colors.green, fontSize: size.width * 0.04),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(color: Colors.black, fontSize: size.width * 0.04),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: Colors.green, fontSize: size.width * 0.04),
                    ),
                  ],
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
                  child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                  onPressed: _signup,
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
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text("Sign In", style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
