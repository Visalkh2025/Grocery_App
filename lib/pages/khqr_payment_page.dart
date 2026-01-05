import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/pages/checkout_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

class KHQRPaymentPage extends StatefulWidget {
  final String qr;
  final int expiration;
  final double amountUsd;
  final int amountKhr;
  final String deepLink;

  const KHQRPaymentPage({
    required this.qr,
    required this.expiration,
    required this.amountUsd,
    required this.amountKhr,
    required this.deepLink,
    Key? key,
  }) : super(key: key);

  @override
  State<KHQRPaymentPage> createState() => _KHQRPaymentPageState();
}

class _KHQRPaymentPageState extends State<KHQRPaymentPage> {
  late Timer _timer;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();

    remainingSeconds = ((widget.expiration - DateTime.now().millisecondsSinceEpoch) ~/ 1000);

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String extractMerchantName(String qr) {
    try {
      int i = 0;

      while (i + 4 <= qr.length) {
        final tag = qr.substring(i, i + 2);
        final len = int.parse(qr.substring(i + 2, i + 4));

        final start = i + 4;
        final end = start + len;

        if (end > qr.length) break;

        final value = qr.substring(start, end);

        // Tag 59 = Merchant Name
        if (tag == "59") return value;

        i = end;
      }

      return "";
    } catch (_) {
      return "";
    }
  }

  String get formattedTime {
    if (remainingSeconds <= 0) return "00:00";

    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return "${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final merchantName = extractMerchantName(widget.qr);
    log("merchant$merchantName");

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "KHQR Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // CARD
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Red header
                  Container(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE1232E),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "KHQR",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    merchantName.isEmpty ? "Merchant" : merchantName,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),

                  const SizedBox(height: 4),

                  // KHR Amount
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.amountKhr} ",
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "KHR", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),

                  // USD amount
                  Text(
                    "${widget.amountUsd} USD",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  // QR
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: QrImageView(
                      data: widget.qr,
                      // embeddedImage: AssetImage('assets/bank_logo.png'),
                      size: 220,
                      backgroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "$formattedTime | QR will be expired",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Divider + OR
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("Or")),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 18),

            // Pay via Bakong App
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: remainingSeconds <= 0
                    ? null
                    : () async {
                        // final url = Uri.parse(widget.deepLink);
                        // await launchUrl(url, mode: LaunchMode.externalApplication);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Pay via Bakong App",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
