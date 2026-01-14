import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controller/review_controller.dart';

class AddReviewSheet extends StatelessWidget {
  final String productId;
  AddReviewSheet({super.key, required this.productId});

  final ReviewController controller = Get.put(ReviewController());
  final TextEditingController commentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // avoid keyboard
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Write a Review",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => IconButton(
                      icon: Icon(
                        i < controller.rating.value ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                      ),
                      onPressed: () => controller.rating.value = i + 1,
                    ),
                  ),
                ),
              ),

              TextField(
                controller: commentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "Share your experience..."),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () =>
                    controller.submitReviews(productId: productId, commentText: commentCtrl.text),
                child: const Text("Submit Review"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
