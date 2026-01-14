import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:grocery_app/controller/order_controller.dart';
import 'package:grocery_app/pages/auth_page.dart';
import 'package:grocery_app/pages/edit_profile.dart';
import 'package:grocery_app/pages/google_map.dart';
import 'package:grocery_app/pages/help_support.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/order_history_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.person_outline, 'title': 'Edit Profile', 'route': () => EditProfile()},
    {'icon': Icons.location_on_outlined, 'title': 'Shop Addresses', 'route': () => GoogleMap()},
    {'icon': Icons.history_rounded, 'title': 'Order History', 'route': () => OrderHistoryPage()},
    {'icon': Icons.notifications_none_outlined, 'title': 'Notifications', 'route': null},
    {'icon': Icons.favorite_border, 'title': 'Wishlist', 'route': null},
    {'icon': Icons.help_outline, 'title': 'Help & Support', 'route': () => HelpSupport()},
  ];

  final AuthController authController = Get.find<AuthController>();
  final OrderController orderController = Get.put(OrderController());
  @override
  void initState() {
    super.initState();
    authController.loadUserFromCache();
  }

  @override
  Widget build(BuildContext context) {
    // final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F2),
      body: Stack(
        children: [
          Container(height: 220, width: double.infinity, color: Colors.green),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Obx(() {
                      final user = authController.user.value;

                      if (user == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Row(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),

                              // image: DecorationImage(
                              //   fit: BoxFit.cover,
                              //   image: user.picture != null && user.picture!.isNotEmpty
                              //       ? NetworkImage(user.picture!)
                              //       : const AssetImage('assets/images/pf.png') as ImageProvider,
                              // ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.picture ?? '',
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Image.asset('assets/images/pf.png', fit: BoxFit.cover),
                                errorWidget: (_, __, ___) =>
                                    Image.asset('assets/images/pf.png', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.email ?? 'No Email',
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Get.to(() => EditProfile());
                            },
                            icon: const Icon(Icons.edit, color: Colors.white),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Orders",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() {
                                return Text(
                                  orderController.orderCount.toString(),
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                );
                              }),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => OrderHistoryPage());
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                              // Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menuItems.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              final page = menuItems[index]['route'];
                              if (page != null) {
                                Get.to(page);
                              }
                            },

                            leading: Icon(menuItems[index]['icon'], color: Colors.black87),
                            title: Text(
                              menuItems[index]['title'],
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await authController.logout();
                          Get.offAll(() => LoginPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF2F3F2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.green),
                        label: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
