import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/pages/order_accepted_page.dart';
import 'package:grocery_app/widget/primary_button.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final List<Map<String, dynamic>> summmaryItems = [
    {"title": "Subtitle", "amount": 430.00},
    {"title": "Shipping", "amount": 0.0, "editable": true},
    {"title": "Estimated Taxes", "amount": 12.00},
    {"title": "Others Fees", "amount": 0.00},
    {"title": "Total", "amount": 442.50, "bold": true},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: groceries.length,
              itemBuilder: (context, index) {
                return Row(
                  spacing: 10,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Color(0xffF0F1f6)),
                      child: Stack(
                        clipBehavior: Clip.none,

                        children: [
                          Image.asset(
                            groceries[index].imagePath,
                            width: 130,
                            height: 130,
                          ),
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              width: 25,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xff727272),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groceries[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(groceries[index].description),
                          Text(
                            "\$${groceries[index].price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
            ),
            SizedBox(height: 15),
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Discount code",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF2F4F3),
                    minimumSize: Size(100, 50),
                    shape: RoundedRectangleBorder(),
                  ),
                  child: Text("Apply"),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: summmaryItems.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    summmaryItems[index]['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: summmaryItems[index]["bold"] == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: Text(
                    summmaryItems[index]["editable"] == true
                        ? "Enter Shipping address"
                        : "\$${summmaryItems[index]["amount"]}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: summmaryItems[index]["bold"] == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(20),
        child: PrimaryButton(text: "Order now", nextPage: OrderAcceptedPage()),
      ),
    );
  }
}
