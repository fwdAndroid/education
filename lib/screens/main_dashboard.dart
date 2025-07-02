import 'package:auto_size_text/auto_size_text.dart';
import 'package:education/advertisement_pages/ads_policy_page.dart';
import 'package:education/advertisement_pages/content_license_page.dart';
import 'package:education/advertisement_pages/gdpr_page.dart';
import 'package:education/advertisement_pages/privacy_policy_page.dart';
import 'package:education/constant/ad_keys.dart';
import 'package:education/constant/chapter_constant.dart';
import 'package:education/encryptions/imageloader_encryption.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/bookmark.dart';
import 'package:education/screens/learning_dashboard.dart';
import 'package:education/screens/quiz/quiz_dashboard.dart';
import 'package:education/utils_colors/colors.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
final ValueNotifier<int> remainingSecondsNotifier = ValueNotifier(0);

class _MainDashboardState extends State<MainDashboard>
    with AnalyticsScreenTracker<MainDashboard> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  String get screenName => 'MainDashboard';
  bool _imagesLoaded = false;
  int _estimatedRemainingSeconds = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initHiveAndPreload();
    // Hide status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // Set background color behind status bar (important for Android notch areas)
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: transparent, // Transparent background
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _loadBannerAd();
    // Hide only the top status bar
  }

  Future<void> _initHiveAndPreload() async {
    final box = Hive.box<Uint8List>('imageCache');
    final allAssets = chapterImagePaths;

    final uncachedAssets =
        allAssets.where((path) => !box.containsKey(path)).toList();

    if (uncachedAssets.isEmpty) {
      // All images already cached; mark as loaded without UI disruption
      setState(() {
        _imagesLoaded = true;
      });
      return;
    }

    final preloader = ImagePreloader(
      assetPaths: uncachedAssets,
      base64Key: base24,
      concurrency: 2,
    );

    final stopwatch = Stopwatch()..start();

    // Optionally store progress in variables without rebuilding UI
    double tempProgress = 0.0;

    await preloader.preloadAllImages(
      onProgress: (loaded, total) {
        final elapsed = stopwatch.elapsed.inSeconds;
        final remaining =
            total == 0
                ? 0
                : (elapsed / (loaded + 1) * (total - loaded)).round();

        progressNotifier.value = loaded / (total == 0 ? 1 : total);
        remainingSecondsNotifier.value = remaining;
      },
    );

    final allCached = allAssets.every((path) => box.containsKey(path));

    if (mounted) {
      setState(() {
        _progress = tempProgress;
        _estimatedRemainingSeconds = 0;
        _imagesLoaded = allCached;
      });
    }

    stopwatch.stop();
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
    progressNotifier.dispose();
    remainingSecondsNotifier.dispose();
    _bannerAd?.dispose();
    Hive.close();
    super.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    base24 = base24; // Make sure this is set properly

    return Scaffold(
      bottomNavigationBar:
          _isBannerAdLoaded && _bannerAd != null
              ? Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
              : const SizedBox(
                height: 50,
                child: Center(child: Text("Ad loading...")),
              ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          // Font sizes based on width (you can tweak these)
          double titleFontSize = screenWidth * 0.04; // ~16 at 400px width
          double subtitleFontSize = screenWidth * 0.03; // ~12 at 400px width

          // Responsive widths for buttons (40% width in portrait, 30% in landscape)
          double buttonWidth =
              orientation == Orientation.portrait
                  ? screenWidth * 0.4
                  : screenWidth * 0.3;

          // Responsive height for buttons
          double buttonHeight =
              orientation == Orientation.portrait
                  ? screenHeight * 0.18
                  : screenHeight * 0.35;

          return Stack(
            children: [
              Positioned.fill(
                child: EnyrptedImageWidget(
                  base64Key: base24,
                  assetPath: "assets/encrypted/bg.png.enc",
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      EnyrptedImageWidget(
                        base64Key: base24,
                        assetPath: "assets/encrypted/logo.png.enc",
                        height: 50,
                      ),
                      SizedBox(height: 16),

                      // Buttons Row (or Column if landscape is narrow)
                      orientation == Orientation.portrait
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildButton(
                                context,
                                base24,
                                width: buttonWidth,
                                height: buttonHeight,
                                assetPath: "assets/encrypted/books.png.enc",
                                label: "LEARNING",
                                onTap: () {
                                  if (_imagesLoaded) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const LearningDashboard(),
                                      ),
                                    );
                                  } else {
                                    _showProgressDialog(context);
                                  }
                                },
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              _buildBookmarkButton(
                                context,
                                base24,
                                width: buttonWidth,
                                height: buttonHeight,
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              _buildButton(
                                context,
                                base24,
                                width: buttonWidth,
                                height: buttonHeight,
                                assetPath: "assets/encrypted/books.png.enc",
                                label: "LEARNING",
                                onTap: () {
                                  if (_imagesLoaded) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const LearningDashboard(),
                                      ),
                                    );
                                  } else {
                                    _showProgressDialog(context);
                                  }
                                },
                              ),
                              SizedBox(height: 16),
                              _buildBookmarkButton(
                                context,
                                base24,
                                width: buttonWidth,
                                height: buttonHeight,
                              ),
                            ],
                          ),

                      SizedBox(height: 10),

                      // Quiz Card
                      Container(
                        alignment: Alignment.center,
                        width:
                            orientation == Orientation.portrait
                                ? screenWidth * 0.95
                                : screenWidth * 0.6,
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
                                leading: EnyrptedImageWidget(
                                  base64Key: base24,
                                  assetPath: "assets/encrypted/quiz.png.enc",
                                  height: 60,
                                ),
                                title: AutoSizeText(
                                  "Play Quiz Challenge",
                                  style: TextStyle(
                                    fontSize:
                                        screenWidth *
                                        0.04, // Responsive font size
                                    fontWeight: FontWeight.bold,
                                    color: black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: EnyrptedImageWidget(
                                  base64Key: base24,
                                  assetPath:
                                      "assets/encrypted/quizbutton.png.enc",
                                  height: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Divider(color: dividerColor, thickness: 1),
                      Text(
                        "Share the app",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),

                      GestureDetector(
                        onTap: () {
                          Share.share(
                            'check out my website https://example.com',
                          );
                        },
                        child: Container(
                          height: 140,
                          width:
                              orientation == Orientation.portrait
                                  ? screenWidth * 0.95
                                  : screenWidth * 0.6,
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
                              const Icon(
                                Icons.share,
                                size: 100,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Share with Friends",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Help your friend fall in love\nwith learning through Alim!",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8,
                          bottom: 8,
                          top: 16,
                        ),
                        child: Divider(
                          color: const Color(0xffb48ce8),
                          thickness: 1,
                        ),
                      ),

                      Text(
                        "We are Secure",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: black,
                          fontSize: 20,
                        ),
                      ),

                      SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (builder) => const PrivacyPolicyPage(),
                                ),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 170,
                              decoration: BoxDecoration(
                                color: borderColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: EnyrptedImageWidget(
                                      base64Key: base24,
                                      assetPath:
                                          "assets/encrypted/privacy.png.enc",
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      color: privacyColor,
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
                            child: EnyrptedImageWidget(
                              base64Key: base24,
                              assetPath: "assets/encrypted/gdpr.png.enc",
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 5),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ContentLicensePage(),
                                ),
                              );
                            },
                            child: EnyrptedImageWidget(
                              base64Key: base24,
                              assetPath:
                                  "assets/encrypted/contentpolicy.png.enc",
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
                            child: EnyrptedImageWidget(
                              base64Key: base24,
                              assetPath: "assets/encrypted/adspolicy.png.enc",
                              height: 40,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
                        child: Text(
                          "Advertisements",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build the "LEARNING" button container
  Widget _buildButton(
    BuildContext context,
    String base64Key, {
    required double width,
    required double height,
    required String assetPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 1.0, color: const Color(0xFFE5E7E9)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Center(
                child: EnyrptedImageWidget(
                  base64Key: base64Key,
                  assetPath: assetPath,
                  height: 50,
                  width: 100,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the bookmark button container
  Widget _buildBookmarkButton(
    BuildContext context,
    String base64Key, {
    required double width,
    required double height,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bookmark()),
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 1.0, color: const Color(0xFFE5E7E9)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 50, color: const Color(0xffb48ce8)),
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
    );
  }
}

void _showProgressDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Loading Learning Content"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: progressNotifier,
              builder: (context, value, _) {
                return LinearProgressIndicator(value: value);
              },
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<int>(
              valueListenable: remainingSecondsNotifier,
              builder: (context, value, _) {
                return Text("Estimated time remaining: ${value}s");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Dismiss"),
          ),
        ],
      );
    },
  );
}
