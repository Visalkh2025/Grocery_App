import 'package:flutter/material.dart';
import 'package:grocery_app/pages/cart_page.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:grocery_app/constants/constant.dart';

import 'package:grocery_app/pages/account_page.dart';
import 'package:grocery_app/pages/explore_page.dart';
import 'package:grocery_app/pages/favorite_page.dart';
import 'package:grocery_app/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const CartPage(),
    const FavoritePage(),
    const AccountPage(),
  ];

  final List<IconData> _icons = [
    Bootstrap.house,
    Bootstrap.search,
    Bootstrap.cart,
    Bootstrap.heart,
    Bootstrap.person,
  ];

  final List<String> _labels = ['Home', 'Search', 'Cart', 'Wishlist', 'Account'];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(_pages.length, (index) => _buildNavItem(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = currentIndex == index;
    final activeColor = Constant.primaryColor;
    final unselectedColor = Colors.grey.shade600;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: isSelected ? 75 : 50,
        height: 50,

        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icons[index], size: 22, color: isSelected ? activeColor : unselectedColor),
              const SizedBox(height: 2),
              Text(
                _labels[index],
                style: TextStyle(
                  color: isSelected ? activeColor : unselectedColor,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
