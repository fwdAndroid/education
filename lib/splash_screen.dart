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
  bool _isAdReady = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _cacheInterstitialAd();

    // Start timer and check for ad readiness after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (_isAdReady && _interstitialAd != null) {
        _interstitialAd!.show();
      } else {
        _goToMainDashboard();
      }
    });
  }

  void _cacheInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test Ad
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdReady = true;

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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainDashboard()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/raw/bg.png"),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),

        child: Center(
          child: Image.asset(
            "assets/raw/bgalim-removebg-preview.png",
            width: 300,
          ),
        ),
      ),
    );
  }
}
