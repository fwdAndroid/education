import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Chapter extends StatefulWidget {
  final List<String> imagePaths;
  final String title;
  final int chapterNumber;

  const Chapter({
    super.key,
    required this.imagePaths,
    required this.title,
    required this.chapterNumber,
  });

  @override
  State<Chapter> createState() => _ChapterState();
}

class _ChapterState extends State<Chapter>
    with AnalyticsScreenTracker<Chapter> {
  BannerAd? _bannerAd;
  String get screenName => 'Chapter';
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: bannerKey,
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
  void dispose() {
    _pageController.dispose();
    _bannerAd?.dispose();
    super.dispose();
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
            child: IconButton(
              icon: Icon(
                BookmarkService().isChapterBookmarked(widget.chapterNumber)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (BookmarkService().isChapterBookmarked(
                    widget.chapterNumber,
                  )) {
                    BookmarkService().removeChapterBookmark(
                      widget.chapterNumber,
                    );
                  } else {
                    BookmarkService().addChapterBookmark(
                      BookmarkedChapter(
                        chapterNumber: widget.chapterNumber,
                        title: widget.title,
                        subtitle: "Chapter ${widget.chapterNumber}",
                        imagePath:
                            "assets/raw/a.png", // Update with correct path
                        imagePaths: widget.imagePaths,
                      ),
                    );
                  }
                });
              },
            ),
          ),
        ],

        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffab77ff),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: Image.asset(
                      widget.imagePaths[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          // Page number display (e.g. "1/5")
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${_currentPage + 1}/${widget.imagePaths.length}',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
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
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
