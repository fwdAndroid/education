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

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Replace with your real ID or test ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _showInterstitialAd();
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
          _checkAuth(); // fallback
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _checkAuth();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _checkAuth();
        },
      );
      _interstitialAd!.show();
    } else {
      _checkAuth();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), _loadInterstitialAd);
  }

  void _checkAuth() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Image.asset(
          'assets/bgalim-removebg-preview.png',
          filterQuality: FilterQuality.high,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
