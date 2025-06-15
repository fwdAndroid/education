import 'dart:math';
import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/helper/encrypted_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChapterProvider extends ChangeNotifier {
  final List<String> imagePaths;
  BannerAd? bannerAd;
  bool isAdLoaded = false;

  int currentPage = 0;
  final TransformationController transformationController =
      TransformationController();

  ChapterProvider({required this.imagePaths}) {
    _loadBannerAd();
  }

  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: bannerKey, // Use your actual ad key here
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          isAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void zoomIn() {
    transformationController.value = transformationController.value.scaled(1.2);
    notifyListeners();
  }

  void zoomOut() {
    transformationController.value = transformationController.value.scaled(0.8);
    notifyListeners();
  }

  void preloadSurroundingImages(String key) {
    final preloadIndices = [currentPage - 1, currentPage + 1];
    for (final i in preloadIndices) {
      if (i >= 0 && i < imagePaths.length) {
        final path = imagePaths[i];
        if (EncryptedImageCache.get(path) == null) {
          decryptImage(path, key);
        }
      }
    }
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    transformationController.dispose();
    super.dispose();
  }
}
