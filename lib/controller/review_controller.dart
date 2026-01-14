import 'package:get/get.dart';
import 'package:grocery_app/models/review_model.dart';
import 'package:grocery_app/service/api/review_service.dart';

class ReviewController extends GetxController {
  final reviews = <ReviewModel>[].obs;
  final isLoading = false.obs;
  final rating = 5.obs;
  final comment = "".obs;
  final isSubmitting = false.obs;

  final ReviewService reviewService = ReviewService();

  //  selected rating (0 = all)
  var selectedRating = 0.obs;
  int countByRating(int rating) {
    return reviews.where((r) => r.rating == rating).length;
  }

  List<ReviewModel> get filteredReviews {
    if (selectedRating.value == 0) {
      return reviews;
    }
    return reviews.where((r) => r.rating == selectedRating.value).toList();
  }

  void setRatingFilter(int rating) {
    selectedRating.value = rating;
  }

  Future<void> fetchReviews(String productId) async {
    try {
      isLoading.value = true;
      reviews.value = await reviewService.getProductReviews(productId);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReviewsMain(String productId) async {
    try {
      isLoading(true);
      final res = await reviewService.getProductReviews(productId);
      reviews.assignAll(res);
    } finally {
      isLoading(false);
    }
  }

  // Future<void> submit(String productId) async {
  //   try {
  //     isSubmitting(true);

  //     final success = await reviewService.submitReview(
  //       productId: productId,
  //       rating: rating.value,
  //       comment: comment.value,
  //     );

  //     if (success) {
  //       Get.back();
  //       Get.snackbar("Success", "Review submitted");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "You already reviewed this product");
  //   } finally {
  //     isSubmitting(false);
  //   }
  // }

  Future<void> submitReviews({required String productId, required String commentText}) async {
    final success = await reviewService.submitReview(
      productId: productId,
      rating: rating.value,
      comment: commentText,
    );

    if (success) {
      fetchReviews(productId);
      // item.isReviewed.value = true;

      Get.back();
    } else {
      Get.snackbar("Error", "Failed to submit review");
    }
  }

  Future<void> deleteReview(String reviewId, String productId) async {
    final success = await reviewService.deleteReview(reviewId);
    if (success) {
      fetchReviews(productId);
    }
  }
}
