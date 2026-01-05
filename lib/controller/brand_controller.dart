import 'package:get/get.dart';
import 'package:grocery_app/models/brand.dart';
import 'package:grocery_app/service/api/brand_service.dart';

class BrandController extends GetxController {
  final BrandService brandService = BrandService();
  final brand = <Brand>[].obs;
  final isLoading = false.obs;
  @override
  void onInit() {
    fetchBrands();
    super.onInit();
  }

  Future<void> fetchBrands() async {
    isLoading(true);
    final res = await brandService.fetchBrands();
    brand.assignAll(res);
    isLoading(false);
  }
}
