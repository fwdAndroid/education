import 'package:auto_size_text/auto_size_text.dart';
import 'package:education/advertisement_pages/ads_policy_page.dart';
import 'package:education/advertisement_pages/content_license_page.dart';
import 'package:education/advertisement_pages/gdpr_page.dart';
import 'package:education/advertisement_pages/privacy_policy_page.dart';
import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/bookmark.dart';
import 'package:education/screens/learning_dashboard.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with AnalyticsScreenTracker<MainDashboard> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  String get screenName => 'MainDashboard';

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    // Hide only the top status bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth * 0.04; // around 16 on 400px width
    double subtitleFontSize = screenWidth * 0.03; // around 12 on 400px width

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/raw/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/raw/logo.png", height: 50),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LearningDashboard(),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          width: 1.0,
                          color: const Color(0xFFE5E7E9),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Center(
                              child: Image.asset(
                                "assets/raw/books.png",
                                height: 50,
                                width: 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "LEARNING",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Bookmark(),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          width: 1.0,
                          color: const Color(0xFFE5E7E9),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark,
                            size: 50,
                            color: const Color(0xffb48ce8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "BookMark",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                width: 400,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFf9f2ff),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizDashboard(),
                        ),
                      );
                    },
                    child: Center(
                      child: ListTile(
                        leading: Image.asset("assets/raw/quiz.png", height: 60),
                        title: AutoSizeText(
                          "Play Quiz Challenge",
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Image.asset(
                          "assets/raw/quizbutton.png",
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: const Color(0xffb48ce8), thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Share the app",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Share.share('check out my website https://example.com');
                  },
                  child: Container(
                    height: 140,
                    width: 460,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6F3C), Color(0xFFff3833)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.share, size: 100, color: Colors.white),

                        // Main Text Block
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Share with Friends",
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Help your friend fall in love\nwith learning through Alim!",
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Arrow Button
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Divider(color: const Color(0xffb48ce8), thickness: 1),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  "We are Secure",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBD4FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Image.asset(
                              "assets/raw/privacy.png",
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: const Color(0xFF8238C6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GdprPage(),
                        ),
                      );
                    },
                    child: Image.asset("assets/raw/gdpr.png", height: 40),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContentLicensePage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/raw/contentpolicy.png",
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdsPolicyPage(),
                        ),
                      );
                    },
                    child: Image.asset("assets/raw/adspolicy.png", height: 40),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
                child: Text(
                  "Advertisements",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Divider(color: const Color(0xffb48ce8), thickness: 1),
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
      ),
    );
  }
}
