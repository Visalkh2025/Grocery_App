import 'package:go_router/go_router.dart';
import 'package:grocery_app/pages/checkout_page.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/pages/order_accepted_page.dart';
import 'package:grocery_app/pages/signup_page.dart';
import 'package:grocery_app/pages/splash_screen.dart';
import 'package:grocery_app/pages/welcome_page.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    //GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => WelcomePage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => SignupPage()),
    //GoRoute(path: '/main', builder: (context, state) => MainPage()),
    GoRoute(path: '/checkout', builder: (context, state) => CheckoutPage()),
    GoRoute(path: '/order-accepted', builder: (context, state) => OrderAcceptedPage()),
  ],
);
