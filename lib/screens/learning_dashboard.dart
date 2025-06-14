import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:education/screens/webpage.dart';
import 'package:education/widgets/chatpter_list_tile.dart';
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
              child: Image.asset("assets/raw/bulb.png", width: 50, height: 50),
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
              imagePath: "assets/raw/a.png",
              imagePaths: [
                "assets/raw/chemxi_Page006.jpg",
                "assets/raw/chemxi_Page007.jpg",
                "assets/raw/chemxi_Page008.jpg",
                "assets/raw/chemxi_Page009.jpg",
              ],
              chapterNumber: 1,
            ),

            //2nd
            ChapterTile(
              title: "Atomic Structure",
              subtitle: "Chapter 2",
              imagePath: "assets/raw/ab.png",
              imagePaths: [
                "assets/raw/chemxi_Page010.jpg",
                "assets/raw/chemxi_Page011.jpg",
                "assets/raw/chemxi_Page012.jpg",
                "assets/raw/chemxi_Page013.jpg",
              ],
              chapterNumber: 2,
            ),
            //3
            ChapterTile(
              title: "Periodic Table",
              subtitle: "Chapter 3",
              imagePath: "assets/raw/abc.png",
              imagePaths: [
                "assets/raw/chemxi_Page014.jpg",
                "assets/raw/chemxi_Page015.jpg",
                "assets/raw/chemxi_Page016.jpg",
                "assets/raw/chemxi_Page017.jpg",
              ],
              chapterNumber: 3,
            ),
            //4
            ChapterTile(
              title: "Chemical Bonding",
              subtitle: "Chapter 4",
              imagePath: "assets/raw/abcd.png",
              imagePaths: [
                "assets/raw/chemxi_Page018.jpg",
                "assets/raw/chemxi_Page019.jpg",
                "assets/raw/chemxi_Page020.jpg",
                "assets/raw/chemxi_Page021.jpg",
              ],
              chapterNumber: 4,
            ),

            //5
            ChapterTile(
              title: "Physical States of Matter",
              subtitle: "Chapter 5",
              imagePath: "assets/raw/a.png",
              imagePaths: [
                "assets/raw/chemxi_Page022.jpg",
                "assets/raw/chemxi_Page023.jpg",
                "assets/raw/chemxi_Page024.jpg",
                "assets/raw/chemxi_Page025.jpg",
              ],
              chapterNumber: 5,
            ),
            //6
            ChapterTile(
              title: "Solutions",
              subtitle: "Chapter 6",
              imagePath: "assets/raw/ab.png",
              imagePaths: [
                "assets/raw/chemxi_Page026.jpg",
                "assets/raw/chemxi_Page027.jpg",
                "assets/raw/chemxi_Page028.jpg",
                "assets/raw/chemxi_Page029.jpg",
              ],
              chapterNumber: 6,
            ),

            //7
            ChapterTile(
              title: "Electrochemistry",
              subtitle: "Chapter 7",
              imagePath: "assets/raw/abc.png",
              imagePaths: [
                "assets/raw/chemxi_Page030.jpg",
                "assets/raw/chemxi_Page031.jpg",
                "assets/raw/chemxi_Page032.jpg",
                "assets/raw/chemxi_Page033.jpg",
              ],
              chapterNumber: 7,
            ),
            //8
            ChapterTile(
              title: "Chemical Reactivity",
              subtitle: "Chapter 8",
              imagePath: "assets/raw/abcd.png",
              imagePaths: [
                "assets/raw/chemxi_Page030.jpg",
                "assets/raw/chemxi_Page031.jpg",
                "assets/raw/chemxi_Page032.jpg",
                "assets/raw/chemxi_Page033.jpg",
              ],
              chapterNumber: 8,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => PDFViewerFromAsset()),
                );
              },
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: ListTile(
                    leading: Image.asset("assets/raw/abcd.png"),
                    subtitle: Text("Chapter 9"),
                    title: Text("PDF Book", style: TextStyle(fontSize: 14)),

                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffab77ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => PDFViewerFromAsset(),
                          ),
                        );
                      },
                      child: Text(
                        "Open",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
}
