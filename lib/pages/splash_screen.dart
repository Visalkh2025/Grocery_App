import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/pages/welcome_page.dart';
import 'package:grocery_app/service/storage/token_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final _tokenStorage = TokenStorage();
  late final AnimationController _controller;
  bool _animationFinished = false;

  Future<void> isLogin() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      Get.off(() => MainPage());
    } else {
      Get.off(() => WelcomePage());
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationFinished = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          isLogin();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _animationFinished
              ? Image.asset(
                  'assets/images/logo/grocery-removebg-preview-removebg-preview.png',
                  key: const ValueKey('logo'),
                  width: 500,
                  height: 500,
                )
              : Lottie.asset(
                  'assets/splash_screen/splash_screen_animation.json',
                  key: const ValueKey('animation'),
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
        ),
      ),
    );
  }
}
