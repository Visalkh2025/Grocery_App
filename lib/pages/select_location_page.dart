import 'package:flutter/material.dart';
import 'package:grocery_app/pages/mobile_number_page.dart';
import 'package:grocery_app/widget/primary_button.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  String selectedZone = "";
  List<String> zones = ["Banaress", "Gulsan", "Dhanmondi", "Uttara"];
  String selectedArea = "";
  List<String> areas = ["Area1", "Area2", "Area3"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 10,
          children: [
            Center(
              child: Image.asset("assets/images/location.png", height: 200),
            ),
            Text(
              "Select your location",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Swich on your location to stay in tune with what's happening in your area",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(flex: 4),
            Align(alignment: Alignment.centerLeft, child: Text("Your Zone")),
            DropdownButtonFormField(
              items: zones
                  .map(
                    (zone) => DropdownMenuItem(value: zone, child: Text(zone)),
                  )
                  .toList(),
              onChanged: (value) {
                value = selectedZone;
              },
            ),
            Align(alignment: Alignment.centerLeft, child: Text("Your Zone")),
            DropdownButtonFormField(
              items: areas
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                value = selectedArea;
              },
            ),
            SizedBox(height: 10),
            //PrimaryButton(text: "Continue", nextPage: MobileNumberPage()),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
