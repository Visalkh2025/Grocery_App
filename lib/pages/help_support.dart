import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // optional light gray background
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "FAQ",
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              "How do I add a transaction?",
              "Click the orange '+' button at the bottom center of the screen.",
            ),
            _buildFaqItem(
              "Can I export my data?",
              "Yes, go to Profile > Export Data to download CSV or PDF.",
            ),
            _buildFaqItem(
              "Is my data safe?",
              "Yes, your data is secured with Supabase Row Level Security.",
            ),
            const SizedBox(height: 30),
            const Text(
              "Contact Us",
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildContactTile(Icons.email, "Email Support", "support@grocery.com"),
            _buildContactTile(Icons.facebook, "Facebook Page", "Grocery Shop"),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, // white background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.grey[200], // subtle divider
        ),
        child: ExpansionTile(
          // iconColor: Colors.orange,
          // collapsedIconColor: Colors.orange,
          iconColor: Constant.primaryColor,

          collapsedIconColor: Constant.primaryColor,
          title: Text(
            question,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(answer, style: TextStyle(color: Colors.grey[700])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, // white background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Constant.primaryColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }
}
