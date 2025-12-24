// import 'package:flutter/material.dart';
// import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
// import 'package:grocery_app/constants/constant.dart';
// import 'package:grocery_app/pages/verification_otp_page.dart';

// class MobileNumberPage extends StatefulWidget {
//   const MobileNumberPage({super.key});

//   @override
//   State<MobileNumberPage> createState() => _MobileNumberPageState();
// }

// class _MobileNumberPageState extends State<MobileNumberPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           spacing: 10,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Enter your mobile phone", style: TextStyle(fontSize: 22)),
//             SizedBox(height: 25),
//             Text("Mobile Number", style: TextStyle(fontSize: 16)),
//             IntlPhoneField(
//               // flagsButtonPadding: EdgeInsetsGeometry.symmetric(horizontal: 15),
//               showDropdownIcon: false,
//               decoration: InputDecoration(
//                 focusedBorder: UnderlineInputBorder(
//                   // borderSide: BorderSide(color: Constant.primaryColor),
//                 ),
//               ),
//               initialCountryCode: 'KH',
//               onChanged: (phone) {
//                 print(phone.completeNumber);
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: SizedBox(
//         width: 70,
//         height: 70,
//         child: FloatingActionButton(
//           backgroundColor: Constant.primaryColor,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => VerificationOtpPage()),
//             );
//           },
//           // onPressed: () => Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (_) =>{})),
//           // ),
//           shape: CircleBorder(),
//           child: Icon(Icons.arrow_forward_ios, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
