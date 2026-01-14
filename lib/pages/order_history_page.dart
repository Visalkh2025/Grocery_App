import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/order_controller.dart';
import 'package:grocery_app/pages/add_review_sheet.dart';
import 'package:grocery_app/utils/currency_format.dart';

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({super.key});

  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isFetchMyOrderLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text("No orders yet", style: TextStyle(fontSize: 16)));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];

            return GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Header: Order Number & Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #${order.orderId.substring(order.orderId.length - 5)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(order.orderStatus).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.orderStatus,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(order.orderStatus),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      //  Horizontal Product Images
                      // SizedBox(
                      //   // width: 100,
                      //   height: 100,
                      //   child: ListView.separated(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: order.items.length,
                      //     separatorBuilder: (_, __) => const SizedBox(width: 12),
                      //     itemBuilder: (context, idx) {
                      //       final item = order.items[idx];
                      //       final imageUrl = item.product.image.isNotEmpty
                      //           ? item.product.image.first
                      //           : "";

                      //       return Column(
                      //         children: [
                      //           ClipRRect(
                      //             borderRadius: BorderRadius.circular(12),
                      //             child: Image.network(
                      //               imageUrl,
                      //               width: 70,
                      //               height: 70,
                      //               fit: BoxFit.cover,
                      //               errorBuilder: (_, __, ___) =>
                      //                   const Icon(Icons.image_not_supported),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 6),

                      //           SizedBox(
                      //             width: 90,
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Flexible(
                      //                   child: Text(
                      //                     item.product.name,
                      //                     maxLines: 1,
                      //                     overflow: TextOverflow.ellipsis,
                      //                     textAlign: TextAlign.center,
                      //                     style: const TextStyle(fontSize: 12),
                      //                   ),
                      //                 ),
                      //                 const SizedBox(width: 4),
                      //                 Text(
                      //                   "x${item.quantity}",
                      //                   style: const TextStyle(
                      //                     fontSize: 12,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),

                      //           // Flexible(
                      //           //   child: Text(
                      //           //     "${item.product.name} x${item.quantity}",
                      //           //     maxLines: 1,
                      //           //     overflow: TextOverflow.ellipsis,
                      //           //     textAlign: TextAlign.center,
                      //           //     style: const TextStyle(fontSize: 12),
                      //           //   ),
                      //           // ),
                      //         ],
                      //       );
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: 145,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: order.items.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, idx) {
                            final item = order.items[idx];
                            final imageUrl = item.product.image.isNotEmpty
                                ? item.product.image.first
                                : "";

                            return Container(
                              width: 100,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    item.product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),

                                  Text("x${item.quantity}", style: const TextStyle(fontSize: 12)),

                                  const SizedBox(height: 6),

                                  // REVIEW BUTTON PER PRODUCT
                                  Obx(
                                    () => item.isReviewed.value
                                        ? const Text(
                                            "Reviewed",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                AddReviewSheet(productId: item.product.id),
                                                isScrollControlled: true,
                                              );
                                              item.isReviewed.value = true;
                                            },
                                            child: Text(
                                              "Review",
                                              style: TextStyle(
                                                color: Constant.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 🔹 Footer: Total items & Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // "${order.itemCount} items • \$${order.totalAmount.toStringAsFixed(2)}",
                            "${order.itemCount} items • ${rielFormat.format(order.totalAmount)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            _formatDate(order.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      // const SizedBox(height: 10),

                      // // 🔹 Action Button
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: OutlinedButton.icon(
                      //     onPressed: () {
                      //       // Get.bottomSheet(
                      //       //   AddReviewSheet(productId: item),
                      //       //   isScrollControlled: true,
                      //       // );
                      //     },
                      //     icon: Icon(Icons.rate_review_sharp, color: Constant.primaryColor),
                      //     label: Text("Review", style: TextStyle(color: Constant.primaryColor)),
                      //     style: OutlinedButton.styleFrom(
                      //       side: BorderSide(color: Constant.primaryColor),
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Processing":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
