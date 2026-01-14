import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/pages/auth_page.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/widget/primary_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final String imgPath = "assets/images/welcome_image.png";
  final String appLogoPath = 'assets/icons/app_icon.svg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(imgPath)),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(30),
            child: Column(
              children: [
                Spacer(),
                // SvgPicture.asset(
                //   appLogoPath,
                //   colorFilter: ColorFilter.mode(Colors.deepOrangeAccent, BlendMode.srcIn),
                //   width: 70,
                //   height: 70,
                // ),
                // Image.asset(Constant.appLogoPath, width: 160, height: 160),
                SizedBox(height: 25),
                Text(
                  "Welcome",
                  style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w600),
                ),

                Text(
                  "To Our Shop",
                  style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w600),
                  // style: TextStyle(color: Colors.black, fontSize: 42, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Get your groceries as fast as in hour",
                  style: TextStyle(color: Colors.white.withValues(alpha: .9), fontSize: 17),
                  // style: TextStyle(color: Colors.black12.withValues(alpha: .7), fontSize: 17),
                ),
                SizedBox(height: 25),

                // SizedBox(
                PrimaryButton(text: "Get Start", nextPage: LoginPage()),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
