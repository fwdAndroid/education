import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/learning_dashboard.dart';
import 'package:education/widgets/quiz_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizDashboard extends StatefulWidget {
  const QuizDashboard({super.key});

  @override
  State<QuizDashboard> createState() => _QuizDashboardState();
}

class _QuizDashboardState extends State<QuizDashboard> {
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
                MaterialPageRoute(builder: (builder) => LearningDashboard()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/raw/Screenshot 2025-05-23 115139.png",
                height: 50,
                width: 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.bookmark, size: 40),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),

        title: Text("Quiz", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffab77ff),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            QuizTile(
              title: "Fundamentals of Chemistry",
              subtitle: "Chapter 1",
              imagePath: "assets/raw/a.png",

              chapterNumber: 1,
            ),
            //2nd
            QuizTile(
              title: "Atomic Structure",
              subtitle: "Chapter 2",
              imagePath: "assets/raw/ab.png",

              chapterNumber: 2,
            ),
            //3
            QuizTile(
              title: "Periodic Table",
              subtitle: "Chapter 3",
              imagePath: "assets/raw/abc.png",

              chapterNumber: 3,
            ),
            //4
            QuizTile(
              title: "Chemical Bonding",
              subtitle: "Chapter 4",
              imagePath: "assets/raw/abcd.png",

              chapterNumber: 4,
            ),

            //5
            QuizTile(
              title: "Physical States of Matter",
              subtitle: "Chapter 5",
              imagePath: "assets/raw/a.png",

              chapterNumber: 5,
            ),
            //6
            QuizTile(
              title: "Solutions",
              subtitle: "Chapter 6",
              imagePath: "assets/raw/ab.png",

              chapterNumber: 6,
            ),

            //7
            QuizTile(
              title: "Electrochemistry",
              subtitle: "Chapter 7",
              imagePath: "assets/raw/abc.png",

              chapterNumber: 7,
            ),
            //8
            QuizTile(
              title: "Chemical Reactivity",
              subtitle: "Chapter 8",
              imagePath: "assets/raw/abcd.png",

              chapterNumber: 8,
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
