import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/bookmark.dart';
import 'package:education/screens/learning_dashboard.dart';
import 'package:education/utils_colors/colors.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:education/screens/quiz/quiz_list_tile.dart';
import 'package:education/screens/quiz/quiz_widget.dart';
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

  // Chapter metadata (only for available chapters)
  final List<Map<String, dynamic>> availableChapters =
      [
            {
              'chapterNumber': 1,
              'title': "Fundamentals of Chemistry",
              'subtitle': "Chapter 1",
              'imagePath': "assets/encrypted/a.png.enc",
            },
            {
              'chapterNumber': 2,
              'title': "Atomic Structure",
              'subtitle': "Chapter 2",
              'imagePath': "assets/encrypted/ab.png.enc",
            },
            {
              'chapterNumber': 3,
              'title': "Periodic Table",
              'subtitle': "Chapter 3",
              'imagePath': "assets/encrypted/abc.png.enc",
            },
            {
              'chapterNumber': 4,
              'title': "Chemical Bonding",
              'subtitle': "Chapter 4",
              'imagePath': "assets/encrypted/abcd.png.enc",
            },
            {
              'chapterNumber': 5,
              'title': "Physical States of Matter",
              'subtitle': "Chapter 5",
              'imagePath': "assets/encrypted/a.png.enc",
            },
            {
              'chapterNumber': 6,
              'title': "Solutions",
              'subtitle': "Chapter 6",
              'imagePath': "assets/encrypted/ab.png.enc",
            },
            {
              'chapterNumber': 7,
              'title': "Electrochemistry",
              'subtitle': "Chapter 7",
              'imagePath': "assets/encrypted/abc.png.enc",
            },
            // {
            //   'chapterNumber': 8,
            //   'title': "Chemical Reactivity",
            //   'subtitle': "Chapter 8",
            //   'imagePath': "assets/encrypted/abcd.png",
            // },
          ]
          .where(
            (chapter) => chapterQuizzes.containsKey(chapter['chapterNumber']),
          )
          .toList();

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

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
      bottomNavigationBar: BottomAppBar(
        color: transparent,
        elevation: 0,
        child:
            _isBannerAdLoaded && _bannerAd != null
                ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
                : const SizedBox(
                  height: 50,
                  child: Center(child: Text("Ad loading...")),
                ),
      ),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const LearningDashboard(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EnyrptedImageWidget(
                base64Key: base24,
                assetPath:
                    "assets/encrypted/Screenshot 2025-05-23 115139.png.enc",
                height: 50,
                width: 50,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => const Bookmark()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.bookmark, size: 40),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: white),
        title: Text("Quiz", style: TextStyle(color: white)),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Only show available chapters
            for (var chapter in availableChapters)
              QuizTile(
                title: chapter['title'],
                subtitle: chapter['subtitle'],
                imagePath: chapter['imagePath'],
                chapterNumber: chapter['chapterNumber'],
              ),
          ],
        ),
      ),
    );
  }
}
