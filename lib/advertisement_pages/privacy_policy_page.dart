import 'package:education/utils_colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final Uri _url = Uri.parse('https://www.google.com/');

  Future<void> _launchURL() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        title: Text("Privacy Policy", style: TextStyle(color: white)),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy Generator",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: black,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16),

              // Paragraphs
              Text(
                "Not everyone knows how to make a Privacy Policy agreement...",
                style: _paragraphStyle(),
              ),
              SizedBox(height: 12),
              Text(
                "We will help you protect yourself by generating a Privacy Policy.",
                style: _paragraphStyle(),
              ),
              SizedBox(height: 12),
              Text(
                "Our Privacy Policy Generator can help you...",
                style: _paragraphStyle(),
              ),
              SizedBox(height: 12),
              Text(
                "Fill in the blank spaces below and we will create a personalized website Privacy Policy...",
                style: _paragraphStyle(),
              ),
              SizedBox(height: 12),
              Text(
                "Small remark when filling in this Privacy Policy generator...",
                style: _paragraphStyle(),
              ),
              SizedBox(height: 24),

              // 🔗 Hyperlink
              Center(
                child: GestureDetector(
                  onTap: _launchURL,
                  child: Text(
                    "Visit Privacy Policy Generator Website",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _paragraphStyle() {
    return TextStyle(fontSize: 14.5, height: 1.6, color: black);
  }
}
