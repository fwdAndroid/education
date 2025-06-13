import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/helper/ads_,manager.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:math';

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
  String get screenName => 'Chapter';
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    AdService().loadBannerAd(bannerKey); // replace with AdKeys.bannerAdUnitId
  }

  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  void _zoomIn() {
    setState(() {
      _currentScale = min(_currentScale + 0.2, 3.0);
      _applyZoom();
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale = max(_currentScale - 0.2, 1.0);
      _applyZoom();
    });
  }

  void _applyZoom() {
    _transformationController.value = Matrix4.identity()..scale(_currentScale);
  }

  @override
  void dispose() {
    _pageController.dispose();

    _transformationController.dispose();
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
                        imagePath: "assets/raw/a.png",
                        imagePaths: widget.imagePaths,
                      ),
                    );
                  }
                });
              },
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xffab77ff),
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
                  _currentScale = 1.0;
                  _applyZoom();
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InteractiveViewer(
                    transformationController: _transformationController,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${_currentPage + 1}/${widget.imagePaths.length}',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_in, color: Colors.black),
                onPressed: _zoomIn,
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out, color: Colors.black),
                onPressed: _zoomOut,
              ),
            ],
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
    );
  }
}
