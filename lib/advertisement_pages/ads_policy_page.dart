import 'package:education/utils/colors.dart';
import 'package:flutter/material.dart';

class AdsPolicyPage extends StatefulWidget {
  const AdsPolicyPage({super.key});

  @override
  State<AdsPolicyPage> createState() => _AdsPolicyPageState();
}

class _AdsPolicyPageState extends State<AdsPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),

        title: Text("Ads Policy", style: TextStyle(color: white)),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ads Policy",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: black,
                  height: 1.4,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),

              // Paragraph 1
              Text(
                "Not everyone knows how to make a Privacy Policy agreement, especially with CCPA or GDPR or CalOPPA or PIPEDA or Australia's Privacy Act provisions. If you are not a lawyer or someone who is familiar with Privacy Policies, you will be clueless. Some people might even take advantage of you because of this. Some people may even extort money from you. These are some examples that we want to stop from happening to you.",
                style: TextStyle(fontSize: 14.5, height: 1.6, color: black),
              ),
              SizedBox(height: 12),

              // Paragraph 2
              Text(
                "We will help you protect yourself by generating a Privacy Policy.",
                style: TextStyle(fontSize: 14.5, height: 1.6, color: black),
              ),
              SizedBox(height: 12),

              // Paragraph 3
              Text(
                "Our Privacy Policy Generator can help you make sure that your business complies with the law. We are here to help you protect your business, yourself and your customers.",
                style: TextStyle(fontSize: 14.5, height: 1.6, color: black),
              ),
              SizedBox(height: 12),

              // Paragraph 4
              Text(
                "Fill in the blank spaces below and we will create a personalized website Privacy Policy for your business. No account registration required. Simply generate & download a Privacy Policy in seconds!",
                style: TextStyle(fontSize: 14.5, height: 1.6, color: black),
              ),
              SizedBox(height: 12),

              // Paragraph 5
              Text(
                "Small remark when filling in this Privacy Policy generator: Not all parts of this Privacy Policy might be applicable to your website. When there are parts that are not applicable, these can be removed. Optional elements can be selected in step 2. The accuracy of the generated Privacy Policy on this website is not legally binding. Use at your own risk.",
                style: TextStyle(fontSize: 14.5, height: 1.6, color: black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
