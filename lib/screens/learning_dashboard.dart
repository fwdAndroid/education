import 'dart:convert';

import 'package:education/constant/ad_keys.dart';
import 'package:education/encryptions/pdf_asset_encrypted.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:education/screens/webpage.dart';
import 'package:education/widgets/chatpter_list_tile.dart';
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
  String get screenName => 'LearningDashboard';
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  final String assetPath = 'assets/encrypted/tests.pdf.enc';
  final String cacheKey = 'test_pdf';

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerKey,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          _isBannerAdLoaded = false;
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
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: EnyrptedImageWidget(
                base64Key: base24,
                assetPath: "assets/encrypted/bulb.png.enc",
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),

        title: Text("Menu", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffab77ff),
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

            //2nd
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
            //3
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
            //4
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

            //5
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
            //6
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

            //7
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
            //8
            ChapterTile(
              title: "Chemical Reactivity",
              subtitle: "Chapter 8",
              imagePath: "assets/encrypted/abcd.png.enc",
              imagePaths: [
                "assets/encrypted/chemxi_Page030.jpg.enc",
                "assets/encrypted/chemxi_Page031.jpg.enc",
                "assets/encrypted/chemxi_Page032.jpg.enc",
                "assets/encrypted/chemxi_Page033.jpg.enc",
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
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
                          // TITLE (single line, clipped if too long)
                          Text(
                            "PDF Book",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.clip, // not ellipsis
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Chapter 9",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffab77ff),
                        minimumSize: const Size(60, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onPressed: () => openEncryptedPdf(context),
                      child: const Text(
                        "Open",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  _bannerAd != null && _isBannerAdLoaded
                      ? Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      )
                      : Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text(
                          "Ad Loading...",
                          style: TextStyle(color: Colors.black, fontSize: 12),
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
      'assets/encrypted/tests.pdf.enc', // already defined in your class
      'test', // same cacheKey
      base64.decode(base24),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PDFViewerFromCache(pdfFile: file)),
    );
  }
}
