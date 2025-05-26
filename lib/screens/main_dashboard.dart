import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/bookmark.dart';
import 'package:education/screens/learning_dashboard.dart';
import 'package:education/screens/privacy_policy.dart';
import 'package:flutter/material.dart';
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
  bool _isAdLoaded = false;
  String get screenName => 'MainDashboard';

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
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/bg.png"),
            filterQuality: FilterQuality.high,
            // Add your background image
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/logo.png", height: 50),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearningDashboard(),
                        ),
                      );
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color:
                            Colors
                                .white, // Equivalent to <solid android:color="@color/white" />
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ), // Equivalent to <corners android:radius="5.0dip" />
                        border: Border.all(
                          width: 1.0,
                          color: Color(
                            0xFFE5E7E9,
                          ), // Equivalent to <stroke android:color="#ffe5e7e9" />
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset("assets/books.png", height: 50),
                          ), // Add your icons
                          SizedBox(height: 12),
                          Text(
                            "LEARNING",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bookmark()),
                      );
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color:
                            Colors
                                .white, // Equivalent to <solid android:color="@color/white" />
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ), // Equivalent to <corners android:radius="5.0dip" />
                        border: Border.all(
                          width: 1.0,
                          color: Color(
                            0xFFE5E7E9,
                          ), // Equivalent to <stroke android:color="#ffe5e7e9" />
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark,
                            size: 50,
                            color: Color(0xffb48ce8),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "BookMark",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFf9f2ff),
                ),
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LearningDashboard(),
                      ),
                    );
                  },
                  child: Center(
                    child: ListTile(
                      leading: Image.asset("assets/quiz.png", height: 60),
                      title: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Play Quiz Challenge",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      trailing: Image.asset(
                        "assets/quizbutton.png",
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.grey, thickness: 1),
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
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text: 'check out my website https://example.com',
                      ),
                    );
                  },
                  child: Container(
                    height: 170,
                    width: 460,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // Colors.red[900]!, // Deep red
                          Colors.red,
                          Colors.orange,
                          // Colors.orange[300]!, // Light orange
                        ],
                        stops: [0.0, 0.3], // Color transition points
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/icq_share.webp",
                                height: 60,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Share with Friends',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Help your friends fall in \nlove with learning through \nthis ALIM!',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/home_cta_img-removebg-preview.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Divider(color: Colors.grey, thickness: 1),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  "We are Secure",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PrivacyPolicy(
                                title: "Privacy Policy",
                                imagePath: "assets/chemxi_Page027.jpg",
                              ),
                        ),
                      );
                    },
                    child: Image.asset("assets/privacy.png", height: 60),
                  ),

                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PrivacyPolicy(
                                title: "GDPR",
                                imagePath: "assets/chemxi_Page027.jpg",
                              ),
                        ),
                      );
                    },
                    child: Image.asset("assets/gdpr.png", height: 60),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PrivacyPolicy(
                                title: "Content License",
                                imagePath: "assets/chemxi_Page027.jpg",
                              ),
                        ),
                      );
                    },
                    child: Image.asset("assets/contentpolicy.png", height: 60),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PrivacyPolicy(
                                title: "Ads Policy",
                                imagePath: "assets/chemxi_Page027.jpg",
                              ),
                        ),
                      );
                    },
                    child: Image.asset("assets/adspolicy.png", height: 60),
                  ),
                ],
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

          // Text section
        ),
      ),
    );
  }
}
