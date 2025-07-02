import 'package:education/constant/ad_keys.dart';
import 'package:education/constant/chapter_constant.dart';
import 'package:education/provider/preload_controller_provider.dart';
import 'package:education/screens/main_dashboard.dart';
import 'package:education/utils_colors/colors.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;
  AppOpenAd? openAd;

  @override
  void initState() {
    super.initState();
    _loadAd();
    _startPreloading();
  }

  void _loadAd() async {
    await AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/3419835294', // Test ID
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('AppOpenAd loaded');
          openAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  Future<void> _startPreloading() async {
    final controller = context.read<PreloadController>();

    final preloadFuture = controller.preloadImages(
      assetPaths: uiImageAssets,
      base64Key: base24,
    );
    final delayFuture = Future.delayed(const Duration(seconds: 5));

    await Future.wait([preloadFuture, delayFuture]);

    _showAdOrNavigate();
  }

  void _showAdOrNavigate() {
    if (openAd == null) {
      print('Ad not ready, navigating directly');
      _navigateToMain();
      return;
    }

    openAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('AppOpenAd shown');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        print('Ad failed to show: $error');
        openAd = null;
        _navigateToMain();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        print('Ad dismissed');
        openAd = null;
        _navigateToMain();
      },
    );

    openAd!.show();
  }

  void _navigateToMain() {
    if (!_navigated && mounted) {
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
      backgroundColor: white,
      body: Stack(
        children: [
          Positioned.fill(
            child: EnyrptedImageWidget(
              base64Key: base24,
              assetPath: "assets/encrypted/bg.png.enc",
              fit: BoxFit.cover,
            ),
          ),
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
