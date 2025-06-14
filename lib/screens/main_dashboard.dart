import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/bookmark.dart';
import 'package:education/screens/helper/ads_,manager.dart';
import 'package:education/screens/learning_dashboard.dart';
import 'package:education/screens/privacy_policy.dart';
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
  String get screenName => 'MainDashboard';
  @override
  void initState() {
    super.initState();
    // Hide only the top status bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    AdService().loadBannerAd(bannerKey); // replace with AdKeys.bannerAdUnitId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
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
                      width: 160,
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
                          Padding(
                            padding: EdgeInsetsGeometry.only(left: 12),
                            child: Center(
                              child: Image.asset(
                                "assets/raw/books.png",
                                height: 50,
                                width: 100,
                              ),
                            ),
                          ), // Add your icons
                          SizedBox(height: 12),
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

                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bookmark()),
                      );
                    },
                    child: Container(
                      width: 160,
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
                              fontSize: 17,
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
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFf9f2ff),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizDashboard(),
                        ),
                      );
                    },
                    child: Center(
                      child: ListTile(
                        leading: Image.asset("assets/raw/quiz.png", height: 60),
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
                child: Divider(color: Color(0xffb48ce8), thickness: 1),
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
                    height: 140,
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
                                "assets/raw/icq_share.webp",
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
                                "assets/raw/home_cta_img-removebg-preview.png",
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
                child: Divider(color: Color(0xffb48ce8), thickness: 1),
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Divider(color: Color(0xffb48ce8), thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
                child: Text(
                  "Advertisments",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFEBD4FB,
                        ), // Light purple background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/raw/privacy.png",
                              height: 60,
                            ),
                          ),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF8238C6), // Purple text
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
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
                                  imagePath: "assets/raw//chemxi_Page027.jpg",
                                ),
                          ),
                        );
                      },
                      child: Image.asset("assets/raw/gdpr.png", height: 60),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PrivacyPolicy(
                                  title: "Content License",
                                  imagePath: "assets/raw/chemxi_Page027.jpg",
                                ),
                          ),
                        );
                      },
                      child: Image.asset(
                        "assets/raw/contentpolicy.png",
                        height: 60,
                      ),
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
                                  imagePath: "assets/raw/chemxi_Page027.jpg",
                                ),
                          ),
                        );
                      },
                      child: Image.asset(
                        "assets/raw/adspolicy.png",
                        height: 60,
                      ),
                    ),
                  ],
                ),
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

          // Text section
        ),
      ),
    );
  }
}
