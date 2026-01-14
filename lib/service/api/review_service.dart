import 'package:grocery_app/models/review_model.dart';
import 'package:grocery_app/utils/api_client.dart';

class ReviewService {
  final ApiClient _api = ApiClient();

  /// Get reviews by product
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final res = await _api.request(endpoint: "review/product/$productId", method: "GET");

    if (res.statusCode == 200) {
      return (res.data['reviews'] as List).map((e) => ReviewModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Create or update review
  Future<bool> submitReviews({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    final res = await _api.request(
      endpoint: "review",
      method: "POST",
      data: {"productId": productId, "rating": rating, "comment": comment},
    );

    return res.statusCode == 200;
  }

  Future<bool> submitReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    final res = await _api.request(
      endpoint: "review",
      method: "POST",
      data: {"productId": productId, "rating": rating, "comment": comment},
    );

    return res.statusCode == 201;
  }

  /// Delete review
  Future<bool> deleteReview(String reviewId) async {
    final res = await _api.request(endpoint: "review/$reviewId", method: "DELETE");

    return res.statusCode == 200;
  }
}
