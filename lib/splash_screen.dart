import 'dart:async';
import 'package:education/screens/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InterstitialAd? _interstitialAd;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Start splash delay and then load ad
    Future.delayed(const Duration(seconds: 2), _loadInterstitialAd);
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _goToMainDashboard();
            },
            onAdFailedToShowFullScreenContent: (
              InterstitialAd ad,
              AdError error,
            ) {
              ad.dispose();
              _goToMainDashboard();
            },
          );

          _interstitialAd!.show();
          _interstitialAd = null;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _goToMainDashboard();
        },
      ),
    );
  }

  void _goToMainDashboard() {
    if (!_navigated) {
      _navigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/bg.png', fit: BoxFit.cover),
          Center(
            child: Image.asset(
              'assets/bgalim-removebg-preview.png',
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    );
  }
}
