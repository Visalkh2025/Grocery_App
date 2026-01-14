import 'package:get/get.dart';
import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/service/api/order_service.dart';

class OrderController extends GetxController {
  final orders = <OrderModel>[].obs;
  final isFetchMyOrderLoading = false.obs;
  RxInt orderCount = 0.obs;

  final OrderService orderService = OrderService();

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  // Future<void> fetchOrdersZin() async {
  //   isFetchMyOrderLoading(true);
  //   final res = await orderService.fetchMyOrders();
  //   // final orderCount = 0.obs;

  //   orders.assignAll(res);

  //   isFetchMyOrderLoading(false);
  // }

  Future<void> fetchOrders() async {
    isFetchMyOrderLoading(true);

    final res = await orderService.fetchMyOrders();

    orders.assignAll(res['orders']);
    orderCount.value = res['count'];

    isFetchMyOrderLoading(false);
  }
}
