import 'dart:convert';

import 'package:education/constant/ad_keys.dart';
import 'package:education/encryptions/pdf_asset_encrypted.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/quiz/quiz_dashboard.dart';
import 'package:education/screens/pdf_page.dart';
import 'package:education/utils_colors/colors.dart';
import 'package:education/screens/chapter/chatpter_list_tile.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LearningDashboard extends StatefulWidget {
  const LearningDashboard({super.key});

  @override
  State<LearningDashboard> createState() => _LearningDashboardState();
}

class _LearningDashboardState extends State<LearningDashboard>
    with AnalyticsScreenTracker<LearningDashboard> {
  @override
  String get screenName => 'LearningDashboard';

  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBannerAd());
  }

  final String assetPath = 'assets/encrypted/tests.pdf.enc';
  final String cacheKey = 'test_pdf';

  void _loadBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.truncate(),
        );

    if (size == null) {
      print('Unable to get adaptive banner size.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: bannerKey, // Replace with your real AdMob unit ID
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            _isBannerAdLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          _isBannerAdLoaded && _bannerAd != null
              ? Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: _bannerAd!.size.height.toDouble(),
                alignment: Alignment.center,
                child: AdWidget(ad: _bannerAd!),
              )
              : const SizedBox(
                height: 50,
                child: Center(child: Text("Ad loading...")),
              ),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => QuizDashboard()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: EnyrptedImageWidget(
                base64Key: base24,
                assetPath: "assets/encrypted/bulb.png.enc",
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: white),
        title: Text("Menu", style: TextStyle(color: white)),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChapterTile(
              title: "Fundamentals of Chemistry",
              subtitle: "Chapter 1",
              imagePath: "assets/encrypted/a.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page006.jpg.enc",
                "assets/encrypted/chemxi_Page007.jpg.enc",
                "assets/encrypted/chemxi_Page008.jpg.enc",
                "assets/encrypted/chemxi_Page009.jpg.enc",
              ],
              chapterNumber: 1,
            ),
            ChapterTile(
              title: "Atomic Structure",
              subtitle: "Chapter 2",
              imagePath: "assets/encrypted/ab.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page010.jpg.enc",
                "assets/encrypted/chemxi_Page011.jpg.enc",
                "assets/encrypted/chemxi_Page012.jpg.enc",
                "assets/encrypted/chemxi_Page013.jpg.enc",
              ],
              chapterNumber: 2,
            ),
            ChapterTile(
              title: "Periodic Table",
              subtitle: "Chapter 3",
              imagePath: "assets/encrypted/abc.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page014.jpg.enc",
                "assets/encrypted/chemxi_Page015.jpg.enc",
                "assets/encrypted/chemxi_Page016.jpg.enc",
                "assets/encrypted/chemxi_Page017.jpg.enc",
              ],
              chapterNumber: 3,
            ),
            ChapterTile(
              title: "Chemical Bonding",
              subtitle: "Chapter 4",
              imagePath: "assets/encrypted/abcd.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page018.jpg.enc",
                "assets/encrypted/chemxi_Page019.jpg.enc",
                "assets/encrypted/chemxi_Page020.jpg.enc",
                "assets/encrypted/chemxi_Page021.jpg.enc",
              ],
              chapterNumber: 4,
            ),
            ChapterTile(
              title: "Physical States of Matter",
              subtitle: "Chapter 5",
              imagePath: "assets/encrypted/a.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page022.jpg.enc",
                "assets/encrypted/chemxi_Page023.jpg.enc",
                "assets/encrypted/chemxi_Page024.jpg.enc",
                "assets/encrypted/chemxi_Page025.jpg.enc",
              ],
              chapterNumber: 5,
            ),
            ChapterTile(
              title: "Solutions",
              subtitle: "Chapter 6",
              imagePath: "assets/encrypted/ab.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page026.jpg.enc",
                "assets/encrypted/chemxi_Page027.jpg.enc",
                "assets/encrypted/chemxi_Page028.jpg.enc",
                "assets/encrypted/chemxi_Page029.jpg.enc",
              ],
              chapterNumber: 6,
            ),
            ChapterTile(
              title: "Electrochemistry",
              subtitle: "Chapter 7",
              imagePath: "assets/encrypted/abc.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page030.jpg.enc",
                "assets/encrypted/chemxi_Page031.jpg.enc",
                "assets/encrypted/chemxi_Page032.jpg.enc",
                "assets/encrypted/chemxi_Page033.jpg.enc",
              ],
              chapterNumber: 7,
            ),
            ChapterTile(
              title: "Chemical Reactivity",
              subtitle: "Chapter 8",
              imagePath: "assets/encrypted/abcd.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page034.jpg.enc",
                "assets/encrypted/chemxi_Page035.jpg.enc",
                "assets/encrypted/chemxi_Page036.jpg.enc",
                "assets/encrypted/chemxi_Page037.jpg.enc",
              ],
              chapterNumber: 8,
            ),
            GestureDetector(
              onTap: () => openEncryptedPdf(context),
              child: Container(
                height: 90,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    EnyrptedImageWidget(
                      base64Key: base24,
                      assetPath: "assets/encrypted/abcd.png.enc",
                      height: 48,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PDF Book",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Chapter 9",
                            style: TextStyle(fontSize: 12, color: grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        minimumSize: const Size(60, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onPressed: () => openEncryptedPdf(context),
                      child: Text("Open", style: TextStyle(color: white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openEncryptedPdf(BuildContext context) async {
    final file = await loadAndDecryptPdfFromAssets(
      assetPath,
      cacheKey,
      base64.decode(base24),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PDFViewerFromCache(pdfFile: file)),
    );
  }
}
