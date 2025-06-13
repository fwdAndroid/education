// ad_service.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  BannerAd? _bannerAd;
  bool get isBannerAdLoaded => _bannerAd != null;

  void loadBannerAd(String adUnitId) {
    if (_bannerAd != null) return;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Banner ad loaded'),
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed: $error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  BannerAd? get bannerAd => _bannerAd;

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }
}
