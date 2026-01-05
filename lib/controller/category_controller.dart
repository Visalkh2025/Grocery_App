import 'package:get/get.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/service/api/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService cateService = CategoryService();
  final category = <Category>[].obs;
  final isLoading = false.obs;
  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    isLoading(true);
    final res = await cateService.fetchCategories();
    category.assignAll(res);
    isLoading(false);
  }
}
