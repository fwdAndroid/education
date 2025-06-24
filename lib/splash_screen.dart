import 'package:education/constant/ad_keys.dart';
import 'package:education/constant/chapter_constant.dart';
import 'package:education/newprovider.dart'; // PreloadController
import 'package:education/screens/main_dashboard.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startPreloading();
  }

  Future<void> _startPreloading() async {
    final controller = context.read<PreloadController>();

    // Start both the preloading and the 3-second timer in parallel
    final preloadFuture = controller.preloadImages(
      assetPaths: uiImageAssets,
      base64Key: base24,
    );

    final delayFuture = Future.delayed(const Duration(seconds: 5));

    // Wait for both to finish
    await Future.wait([preloadFuture, delayFuture]);

    // Navigate only once
    if (mounted && !_navigated) {
      _navigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

          // Centered logo
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EnyrptedImageWidget(
                  base64Key: base24,
                  assetPath:
                      "assets/encrypted/Screenshot_2025-06-14_092856-removebg-preview.png.enc",
                  width: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
