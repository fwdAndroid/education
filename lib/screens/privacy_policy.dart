import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  String title;
  String imagePath;
  PrivacyPolicy({super.key, required this.title, required this.imagePath});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffab77ff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(widget.imagePath, fit: BoxFit.fill),
      ),
    );
  }
}
