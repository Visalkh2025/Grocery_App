import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/pages/OTP_page.dart';
import 'package:grocery_app/pages/auth_page.dart';
import 'package:grocery_app/pages/checkout_page.dart';
import 'package:grocery_app/pages/home_page.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/pages/order_accepted_page.dart';
import 'package:grocery_app/pages/signup_page.dart';
import 'package:grocery_app/pages/splash_screen.dart';
import 'package:grocery_app/pages/welcome_page.dart';
import 'package:grocery_app/service/storage/token_storage.dart';

// void main() {
//   runApp(MyApp());
// }
Future main() async {
  await dotenv.load(fileName: ".env");
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final _tokenStorage = TokenStorage();

  // Future<void> isLogin() async {
  //   // await Future.delayed(const Duration(milliseconds: 500));
  //   final token = await _tokenStorage.getToken();

  //   if (token != null) {
  //     Get.offAll(() => MainPage(), transition: Transition.fadeIn);
  //   } else {
  //     Get.offAll(() => WelcomePage(), transition: Transition.fadeIn);
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        appBarTheme: AppBarTheme(scrolledUnderElevation: 0.0, elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffE2E2E2))),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffE2E2E2))),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffE2E2E2))),
        ),
        // bottomSheetTheme: BottomSheetThemeData(
        //   backgroundColor: Colors.transparent,
        // ),
      ),

      home: SplashScreen(),
    );
  }
}
