import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/pages/email_page.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/pages/select_location_page.dart';
import 'package:grocery_app/service/google_signin_service.dart';
import 'package:grocery_app/utils/snackbar_helper.dart';
import 'package:grocery_app/widget/primary_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _LoginPageState();
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LoginPageState extends State<AuthPage> {
  final String loginSlidePath = "assets/images/login-slide.png";
  final String googleLogo = "assets/icons/icons8-google-96.png";
  final String fblogo = "assets/icons/icons8-facebook-f-96.png";
  final GoogleSigninService _googleSignInService = GoogleSigninService();
  final AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.07;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withValues(alpha: .1),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipPath(
                    clipper: BottomCurveClipper(),

                    child: Image.asset(
                      loginSlidePath,
                      width: size.width,
                      height: size.height * 0.40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Text(
                    "Get your groceries",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.065),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter your phone number",
                      hintStyle: TextStyle(color: Colors.grey[500], fontSize: size.width * 0.03),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 0),
                        child: CountryCodePicker(
                          flagWidth: size.width * 0.06,
                          dialogSize: Size(size.width * 0.9, size.height * 0.7),

                          initialSelection: "KH",
                          showFlag: true,
                          showDropDownButton: true,
                          padding: EdgeInsets.zero,
                          textStyle: TextStyle(fontSize: size.width * 0.03, color: Colors.black),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: size.height * 0.015,
                        horizontal: 8,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                        borderSide: const BorderSide(color: Color(0xff53B176), width: 1),
                      ),
                    ),
                    style: TextStyle(fontSize: size.width * 0.045, color: Colors.black),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: PrimaryButton(
                    text: "Login",
                    fontSize: size.width * 0.045,
                    nextPage: LoginPage(),
                  ),
                ),

                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey.shade300,
                          endIndent: 10,
                          indent: size.width * 0.1,
                        ),
                      ),
                      const Text("or"),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey.shade300,
                          indent: 10,
                          endIndent: size.width * 0.1,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: authController.isLoading.value
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: size.height * 0.055,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff5583EC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 0.04),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              await _googleSignInService.signOut();
                              GoogleSignInAccount? user = await _googleSignInService
                                  .signInWithGoogle();
                              final GoogleSignInAuthentication? auth = await user?.authentication;
                              log("IDTOKen: ${auth?.idToken}");
                              // authController.loginGoogle(auth?.idToken?.toString() ?? '');
                              final res = await authController.loginGoogle(
                                auth?.idToken?.toString() ?? "",
                              );
                              if (res['success'] == true) {
                                // SnackbarHelper.showSuccess('Success', res.message);
                                // log("Token saved: ${res.token}");
                                // log("User info: ${res.message}");
                                Future.delayed(const Duration(milliseconds: 1000), () {
                                  Get.off(() => MainPage());
                                });
                              } else {
                                // SnackbarHelper.showError('Error', res.message);
                              }
                            },
                            icon: Image.asset(
                              googleLogo,
                              color: Colors.white,
                              width: size.width * 0.07,
                              height: size.width * 0.07,
                            ),
                            label: Text(
                              "Continue with Google",
                              style: TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                ),

                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: SizedBox(
                    width: double.infinity,
                    height: size.height * 0.055,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 15, 48, 127),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(size.width * 0.04),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Get.to(() => EmailPage());
                      },
                      icon: Image.asset(
                        fblogo,
                        color: Colors.white,
                        width: size.width * 0.07,
                        height: size.width * 0.07,
                      ),
                      label: Text(
                        "Continue with Facebook",
                        style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
