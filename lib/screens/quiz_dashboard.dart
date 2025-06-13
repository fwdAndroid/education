import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/helper/ads_,manager.dart';
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
  @override
  void initState() {
    super.initState();
    AdService().loadBannerAd(bannerKey); // replace with AdKeys.bannerAdUnitId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Image.asset("assets/raw/bulb.png", width: 50, height: 50),
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
              child: ValueListenableBuilder<bool>(
                valueListenable: AdService().isBannerAdLoaded,
                builder: (context, isLoaded, child) {
                  return isLoaded && AdService().bannerAd != null
                      ? Container(
                        alignment: Alignment.center,
                        width: AdService().bannerAd!.size.width.toDouble(),
                        height: AdService().bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: AdService().bannerAd!),
                      )
                      : Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Ad Loading...",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
