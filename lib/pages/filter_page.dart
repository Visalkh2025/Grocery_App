import 'package:flutter/material.dart';
import 'package:grocery_app/widget/custom_checkbox.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool isChecked = false;
  final List<String> categoriesName = [
    "Dairy & Eggs",
    "Fresh Fruit & Vegetable",
    "Coconut Oil",
    "Meat & Fish",
    "Backery & Snacks",
    "Beverages",
  ];
  final List<String> brands = ["Brand A", "Brand B", "Brand C", "Brand D", "Brabd E", "Brand F"];
  // late List<
  //   bool
  // >
  // selectedCategories = [];
  late List<bool> selectedCategories = List.generate(categoriesName.length, (index) => false);
  late List<bool> selectedBrands = List.generate(brands.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded),
        ),
        title: Text("Filters", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Color(0xFFF2F3F2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Categories", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            // Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(
            //           () {
            //             isChecked = !isChecked;
            //           },
            //         );
            //       },
            //       child: AnimatedContainer(
            //         duration: const Duration(
            //           milliseconds: 200,
            //         ),
            //         width: 25,
            //         height: 25,
            //         decoration: BoxDecoration(
            //           color: isChecked
            //               ? Colors.green
            //               : Colors.transparent,
            //           borderRadius: BorderRadius.circular(
            //             5,
            //           ),
            //           border: Border.all(
            //             color: isChecked
            //                 ? Colors.green
            //                 : Colors.grey.shade400,
            //             width: 2,
            //           ),
            //           boxShadow: [
            //             if (isChecked)
            //               BoxShadow(
            //                 color: Colors.green.withValues(
            //                   alpha: .3,
            //                 ),
            //                 blurRadius: 6,
            //                 offset: const Offset(
            //                   0,
            //                   2,
            //                 ),
            //               ),
            //           ],
            //         ),
            //         child: isChecked
            //             ? const Icon(
            //                 Icons.check,
            //                 color: Colors.white,
            //                 size: 18,
            //               )
            //             : null,
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     const Text(
            //       "Eggs",
            //       style: TextStyle(
            //         color: Colors.black87,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),
            ListView.builder(
              itemCount: categoriesName.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCheckbox(
                    value: selectedCategories[index],
                    label: categoriesName[index],
                    onChanged: (value) {
                      setState(() {
                        selectedCategories[index] = value;
                      });
                    },
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            Text("Brands", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ListView.builder(
              itemCount: categoriesName.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCheckbox(
                    value: selectedBrands[index],
                    label: brands[index],
                    onChanged: (value) {
                      setState(() {
                        selectedBrands[index] = value;
                      });
                    },
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff53B176),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Filter",
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
