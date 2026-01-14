import 'dart:developer';

import 'package:grocery_app/models/wishlist.dart';
import 'package:grocery_app/utils/api_client.dart';

class WishlishService {
  final ApiClient _api = ApiClient();
  Future<void> createWishList({required String proId}) async {
    try {
      final res = await _api.request(
        endpoint: "wishlist",
        method: "POST",
        data: {"productId": proId},
      );
      if (res.statusCode == 201) {
        log(res.data['message']);
      } else {
        log(res.data['message']);
      }
    } catch (err) {
      log("Error create WishLish: $err");
    }
  }

  Future<Wishlist> fetchWishList() async {
    try {
      final res = await _api.request(endpoint: "wishlist", method: "GET");
      if (res.statusCode == 200) {
        final data = res.data as Map<String, dynamic>;
        return Wishlist.fromJson(data);
      } else {
        return Wishlist.empty();
      }
    } catch (err) {
      log("Error creating wishlist: $err");
      return Wishlist.empty();
    }
  }

  Future<void> removeWishlist({required String proId}) async {
    try {
      final res = await _api.request(endpoint: "wishlist/$proId", method: "DELETE");
      if (res.statusCode == 200) {
        log("wishlist remove success");
      } else {
        log("faild to remove wishlist");
      }
    } catch (err) {
      log("Error remove wishlist: $err");
    }
  }

  Future<bool> isIsWishlist({required String proId}) async {
    try {
      final res = await _api.request(endpoint: "wishlist/is_in_wishlist/$proId", method: "GET");
      if (res.statusCode == 200) {
        return res.data['isInWishList'] == true;
      } else {
        return res.data['isInWishList'] == false;
      }
    } catch (err) {
      log("Error fetching isInWishlist : $err");
      return false;
    }
  }
}
