import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Chapter extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ChapterScreen(
      title: title,
      chapterNumber: chapterNumber,
      imagePaths: imagePaths,
    );
  }
}

class ChapterScreen extends StatefulWidget {
  final String title;
  final int chapterNumber;
  final List<String> imagePaths;

  const ChapterScreen({
    super.key,
    required this.title,
    required this.chapterNumber,
    required this.imagePaths,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  int currentPage = 0;
  late PageController _pageController;
  late TransformationController _transformationController;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _transformationController = TransformationController();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerKey,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void _zoomIn() {
    final matrix = _transformationController.value.clone();
    _transformationController.value = matrix..scale(1.2);
  }

  void _zoomOut() {
    final matrix = _transformationController.value.clone();
    _transformationController.value = matrix..scale(0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xffab77ff),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizDashboard()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: EnyrptedImageWidget(
                base64Key: base24,
                assetPath: "assets/encrypted/bulb.png.enc",
                width: 50,
                height: 50,
              ),
            ),
          ),
          IconButton(
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
                  BookmarkService().removeChapterBookmark(widget.chapterNumber);
                } else {
                  BookmarkService().addChapterBookmark(
                    BookmarkedChapter(
                      chapterNumber: widget.chapterNumber,
                      title: widget.title,
                      subtitle: "Chapter ${widget.chapterNumber}",
                      imagePath: "assets/encrypted/a.png.enc",
                      imagePaths: widget.imagePaths,
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Image content
          SizedBox(
            height: screenHeight * 0.7,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EnyrptedImageWidget(
                    assetPath: widget.imagePaths[index],
                    base64Key: base24,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          // Page indicator
          SizedBox(
            height: screenHeight * 0.04,
            child: Center(
              child: Text(
                '${currentPage + 1}/${widget.imagePaths.length}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),

          // Zoom buttons
          SizedBox(
            height: screenHeight * 0.08,
            child: Row(
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
          ),

          // Loading progress (only show while loading)

          // Ad
          SizedBox(
            height: screenHeight * 0.08,
            child:
                _isAdLoaded
                    ? SizedBox(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    )
                    : const Text(
                      "Ad Loading...",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
          ),
        ],
      ),
    );
  }
}
