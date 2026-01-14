import 'package:get/get.dart';
import 'package:grocery_app/models/wishlist.dart';
import 'package:grocery_app/service/api/wishlish_service.dart';

class WishlistController extends GetxController {
  final WishlishService wishListService = WishlishService();
  final Rx<Wishlist> wishlist = Rx(Wishlist.empty());
  final isLoading = false.obs;
  final isInWishlistProduct = false.obs;

  Future<void> createWishList({required String proId}) async {
    await wishListService.createWishList(proId: proId);
  }

  Future<void> toggleWishlist({required String productId}) async {
    if (isInWishlistProduct.isTrue) {
      await removeWishlist(productId: productId);
      isInWishlistProduct(false);
    } else {
      await createWishList(proId: productId);
      isInWishlistProduct(true);
    }
  }

  Future<void> removeWishlist({required String productId}) async {
    int index = wishlist.value.items.indexWhere((item) => item.product!.id == productId);

    await wishListService.removeWishlist(proId: productId);
    if (index != -1) {
      wishlist.value.items.removeAt(index);
      wishlist.refresh();
    }
  }

  Future<void> isInWishlist({required String productId}) async {
    isInWishlistProduct.value = await wishListService.isIsWishlist(proId: productId);
  }

  Future<void> fetchWishlist() async {
    isLoading(true);
    final data = await wishListService.fetchWishList();
    wishlist.value = data;
    isLoading(false);
  }
}
