import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/auth_controller.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final emailcontroller = TextEditingController();
  final isLoading = false.obs;
  File? _profileImage;
  String? _oldImageUrl;

  final ImagePicker _picker = ImagePicker();
  final AuthController authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();

    final user = authController.user.value;
    if (user != null) {
      nameController.text = user.username ?? '';
      _oldImageUrl = user.picture;
      emailcontroller.text = user.email ?? '';
    }
  }

  Future<void> _showImageSourceSelector() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 80);

      if (pickedFile != null && mounted) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  // Future<void> _pickImage() async {
  //   try {
  //     final XFile? pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 80,
  //     );

  //     if (pickedFile != null && mounted) {
  //       setState(() {
  //         _profileImage = File(pickedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Image picker error: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: Stack(
            //     children: [
            //       Container(
            //         width: 100,
            //         height: 100,
            //         decoration: BoxDecoration(
            //           color: Colors.grey[200],
            //           shape: BoxShape.circle,
            //           border: Border.all(color: Constant.primaryColor, width: 2),
            //         ),
            //         child: const Icon(Icons.person, color: Colors.black54, size: 60),
            //       ),
            //       Positioned(
            //         bottom: 0,
            //         right: 0,
            //         child: Container(
            //           padding: const EdgeInsets.all(6),
            //           decoration: BoxDecoration(
            //             color: Constant.primaryColor,
            //             shape: BoxShape.circle,
            //           ),
            //           child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Constant.primaryColor, width: 2),
                      color: Colors.grey[200],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_oldImageUrl != null && _oldImageUrl!.isNotEmpty
                                      ? NetworkImage(_oldImageUrl!)
                                      : const AssetImage('assets/images/pf.png'))
                                  as ImageProvider,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImageSourceSelector,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Constant.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            const Text("Username", style: TextStyle(color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person_outline, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Email", style: TextStyle(color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              controller: emailcontroller,
              readOnly: true,
              style: const TextStyle(color: Colors.black54),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
              ),
            ),

            // const Spacer(),
            const SizedBox(height: 40),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final res = await authController.editProfile(
                      nameController.text.trim(),
                      _profileImage?.path,
                    );
                    log(res.toString());

                    if (res['success'] == true) {
                      Get.back();
                      Get.snackbar("Success", "Profile updated");
                    } else {
                      Get.snackbar("Error", res['message'] ?? "Update failed");
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
