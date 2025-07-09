import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/quiz/quiz_dashboard.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/utils_colors/colors.dart';
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
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _transformationController = TransformationController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBannerAd());
  }

  void _loadBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.truncate(),
        );

    if (size == null) {
      print('Failed to get adaptive banner size');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: bannerKey,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() => _isAdLoaded = false);
        },
      ),
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
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar:
          _isAdLoaded && _bannerAd != null
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
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        title: Text(
          widget.title,
          style: TextStyle(
            color: white,
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
              color: white,
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
          SizedBox(
            height: screenHeight * 0.04,
            child: Center(
              child: Text(
                '${currentPage + 1}/${widget.imagePaths.length}',
                style: TextStyle(fontSize: 16, color: black),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.zoom_in, color: black),
                  onPressed: _zoomIn,
                ),
                IconButton(
                  icon: Icon(Icons.zoom_out, color: black),
                  onPressed: _zoomOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
