import 'dart:async';
import 'dart:typed_data';

import 'package:education/constant/ad_keys.dart';
import 'package:education/imageloader.dart';
import 'package:education/main.dart';
import 'package:education/screens/main_dashboard.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;
  bool _navigated = false;

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initHiveAndPreload();
    Timer.periodic(Duration(seconds: 4), (_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (builder) => MainDashboard()),
      );
    });
  }

  Future<void> _initHiveAndPreload() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);
    await Hive.openBox<Uint8List>('imageCache');

    final preloader = ImagePreloader(
      assetPaths: [
        "assets/encrypted/bulb.png.enc",
        "assets/encrypted/adspolicy.png.enc",
        "assets/encrypted/gdpr.png.enc",
        "assets/encrypted/privacy.png.enc",
      ],
      base64Key: base24,
      concurrency: 4,
    );

    await preloader.preloadAllImages(
      onProgress: (loaded, total) {
        setState(() {
          _progress = loaded / total;
        });
      },
    );

    // _loadAndShowInterstitialAd();
  }

  void _loadAndShowInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
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
          if (_isAdReady && _interstitialAd != null) {
            _interstitialAd!.show();
          } else {
            _goToMainDashboard();
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial ad failed to load: $error');
          _goToMainDashboard();
        },
      ),
    );
  }

  void _goToMainDashboard() {
    if (!_navigated) {
      _navigated = true;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainDashboard()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Your encrypted background image, change path if needed
          Positioned.fill(
            child: EnyrptedImageWidget(
              base64Key: base24,
              assetPath: "assets/encrypted/bg.png.enc",
            ),
          ),

          // Center logo or splash content
          Center(
            child: EnyrptedImageWidget(
              base64Key: base24,
              assetPath:
                  "assets/encrypted/Screenshot_2025-06-14_092856-removebg-preview.png.enc",
              width: 300,
            ),
          ),

          // Progress bar and text overlay at bottom
          if (_progress < 1.0) ...[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.black,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.purple,
                      ),
                      minHeight: 6,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Loading... ${(_progress * 100).toInt()}%',
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
