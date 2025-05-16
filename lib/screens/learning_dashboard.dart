import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
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
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  String get screenName => 'LearningDashboard';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: bannerKey, // Test Ad Unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              imagePath: "assets/a.png",
              imagePaths: [
                "assets/chemxi_Page006.jpg",
                "assets/chemxi_Page007.jpg",
                "assets/chemxi_Page008.jpg",
                "assets/chemxi_Page009.jpg",
              ],
              chapterNumber: 1,
            ),
            //2nd
            ChapterTile(
              title: "Atomic Structure",
              subtitle: "Chapter 2",
              imagePath: "assets/ab.png",
              imagePaths: [
                "assets/chemxi_Page010.jpg",
                "assets/chemxi_Page011.jpg",
                "assets/chemxi_Page012.jpg",
                "assets/chemxi_Page013.jpg",
              ],
              chapterNumber: 2,
            ),
            //3
            ChapterTile(
              title: "Periodic Table",
              subtitle: "Chapter 3",
              imagePath: "assets/abc.png",
              imagePaths: [
                "assets/chemxi_Page014.jpg",
                "assets/chemxi_Page015.jpg",
                "assets/chemxi_Page016.jpg",
                "assets/chemxi_Page017.jpg",
              ],
              chapterNumber: 3,
            ),
            //4
            ChapterTile(
              title: "Chemical Bonding",
              subtitle: "Chapter 4",
              imagePath: "assets/abcd.png",
              imagePaths: [
                "assets/chemxi_Page018.jpg",
                "assets/chemxi_Page019.jpg",
                "assets/chemxi_Page020.jpg",
                "assets/chemxi_Page021.jpg",
              ],
              chapterNumber: 4,
            ),

            //5
            ChapterTile(
              title: "Physical States of Matter",
              subtitle: "Chapter 5",
              imagePath: "assets/a.png",
              imagePaths: [
                "assets/chemxi_Page022.jpg",
                "assets/chemxi_Page023.jpg",
                "assets/chemxi_Page024.jpg",
                "assets/chemxi_Page025.jpg",
              ],
              chapterNumber: 5,
            ),
            //6
            ChapterTile(
              title: "Solutions",
              subtitle: "Chapter 6",
              imagePath: "assets/ab.png",
              imagePaths: [
                "assets/chemxi_Page026.jpg",
                "assets/chemxi_Page027.jpg",
                "assets/chemxi_Page028.jpg",
                "assets/chemxi_Page029.jpg",
              ],
              chapterNumber: 6,
            ),

            //7
            ChapterTile(
              title: "Electrochemistry",
              subtitle: "Chapter 7",
              imagePath: "assets/abc.png",
              imagePaths: [
                "assets/chemxi_Page030.jpg",
                "assets/chemxi_Page031.jpg",
                "assets/chemxi_Page032.jpg",
                "assets/chemxi_Page033.jpg",
              ],
              chapterNumber: 7,
            ),
            //8
            ChapterTile(
              title: "Chemical Reactivity",
              subtitle: "Chapter 8",
              imagePath: "assets/abcd.png",
              imagePaths: [
                "assets/chemxi_Page030.jpg",
                "assets/chemxi_Page031.jpg",
                "assets/chemxi_Page032.jpg",
                "assets/chemxi_Page033.jpg",
              ],
              chapterNumber: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  _isAdLoaded
                      ? Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      )
                      : Center(
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.block, color: Colors.red, size: 30),
                              Text(
                                "Ad Blocked or Not Loaded",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
