import 'dart:async';
import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/main_dashboard.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loadingComplete = false;

  final List<String> _splashAssets = [
    "assets/encrypted/bg.png.enc",
    "assets/encrypted/Screenshot_2025-06-14_092856-removebg-preview.png.enc",
    "assets/encrypted/bulb.png.enc",
    "assets/encrypted/adspolicy.png.enc",
    "assets/encrypted/gdpr.png.enc",
    "assets/encrypted/privacy.png.enc",
    "assets/encrypted/logo.png.enc",
    "assets/encrypted/books.png.enc",
  ];

  @override
  void initState() {
    super.initState();
    _initAndPreload();
  }

  Future<void> _initAndPreload() async {
    await _precacheEncryptedImages();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainDashboard()),
      );
    }
  }

  Future<void> _precacheEncryptedImages() async {
    for (final path in _splashAssets) {
      final loader = StreamedEncryptedImageLoader(path, base24);
      try {
        await loader.decryptStream(); // Fills memory + Hive cache
      } catch (e) {
        debugPrint("Error preloading $path: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: EnyrptedImageWidget(
              base64Key: base24,
              assetPath: "assets/encrypted/bg.png.enc",
              fit: BoxFit.cover,
            ),
          ),

          // Center logo
          Center(
            child: EnyrptedImageWidget(
              base64Key: base24,
              assetPath:
                  "assets/encrypted/Screenshot_2025-06-14_092856-removebg-preview.png.enc",
              width: 300,
            ),
          ),

          // Loading indicator
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
