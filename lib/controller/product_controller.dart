import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/service/api/product_service.dart';

class ProductController extends GetxController {
  final ProductService productService = ProductService();
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  final String sort;
  ProductController({this.sort = ""});
  final products = <Product>[].obs;
  final selectProduct = Rxn<Product>();
  final isProductsLoading = false.obs;
  final isSingleProductLoading = false.obs;
  final isProductByCateLoading = false.obs;
  final isSearchLoading = false.obs;
  final searchProducts = <Product>[].obs;

  Future<void> fetchProducts({bool refresh = false}) async {
    isProductsLoading(true);
    // await Future.delayed(Duration(seconds: 10));
    final res = await productService.fetchProducts(sort: sort);
    products.assignAll(res);
    isProductsLoading(false);
  }

  Future<void> fetchProductsByCategory({required String categoryId}) async {
    isProductByCateLoading(true);
    final data = await productService.fetchProductsByCategory(categoryId);
    products.assignAll(data);
    isProductByCateLoading(false);
  }

  Future<void> fetchSingleProduct({required String productId}) async {
    isSingleProductLoading(true);
    final data = await productService.fetchSingleProduct(productId: productId);
    selectProduct.value = data;
    isSingleProductLoading(false);
  }

  Future<void> searchProduct({required String query}) async {
    isSearchLoading(true);
    final data = await productService.searchProduct(query);
    searchProducts.assignAll(data);
    isSearchLoading(false);
  }
}
