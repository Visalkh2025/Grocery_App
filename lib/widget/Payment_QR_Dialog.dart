// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../controller/payment_controller.dart';

// void showKHQRDialog(BuildContext context, PaymentController controller) {
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Obx(() {
//         final payment = controller.paymentData?.value;
//         final seconds = controller.countdown.value;
//         final minutesDisplay = (seconds ~/ 60).toString().padLeft(2, '0');
//         final secondsDisplay = (seconds % 60).toString().padLeft(2, '0');

//         if (payment == null) return SizedBox.shrink();

//         return Container(
//           padding: EdgeInsets.all(20),
//           width: 300,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Scan KHQR to Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 20),
//               QrImageView(
//                 data: payment['qr'], // the string QR code
//                 size: 200,
//                 backgroundColor: Colors.white,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "$minutesDisplay:$secondsDisplay remaining",
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => controller.isChecking(),
//                 child: Obx(
//                   () => controller.isChecking.value
//                       ? SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                         )
//                       : Text("Check Payment"),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     ),
//     barrierDismissible: false,
//   );
// }
