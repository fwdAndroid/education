import 'package:education/widgets/chatpter_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/chapter.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  final BookmarkService _bookmarkService = BookmarkService();

  bool _isLoading = true;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _loadBannerAd();
  }

  Future<void> _loadBookmarks() async {
    await _bookmarkService.loadBookmarks();
    setState(() {
      _isLoading = false;
    });
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerKey,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bookmarkedChapters = _bookmarkService.bookmarkedChapters;
    final bookmarkedPages = _bookmarkService.bookmarkedPages;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
        backgroundColor: const Color(0xffab77ff),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizDashboard()),
              );
            },
            child: EnyrptedImageWidget(
              assetPath: "assets/encrypted/bulb.png.enc",
              base64Key: base24,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (bookmarkedChapters.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bookmarked Chapters"),
              ),
            ...bookmarkedChapters.map(
              (chapter) => ChapterTile(
                title: chapter.title,
                subtitle: chapter.subtitle,
                imagePath: chapter.imagePath,
                imagePaths: chapter.imagePaths,
                chapterNumber: chapter.chapterNumber,
                isBookmarked: true,
                onBookmarkChanged: (isBookmarked) {
                  if (!isBookmarked) {
                    setState(() {
                      _bookmarkService.removeChapterBookmark(
                        chapter.chapterNumber,
                      );
                    });
                  }
                },
              ),
            ),
            if (bookmarkedPages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bookmarked Pages"),
              ),
            ...bookmarkedPages.map(
              (page) => Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: EnyrptedImageWidget(
                    assetPath: page.imagePath,
                    base64Key: base24,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(
                    "${page.chapterTitle} - Page ${page.pageNumber + 1}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.purple),
                    onPressed: () {
                      setState(() {
                        _bookmarkService.removePageBookmark(
                          page.chapterNumber,
                          page.pageNumber,
                        );
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => Chapter(
                              chapterNumber: page.chapterNumber,
                              title: page.chapterTitle,
                              imagePaths: [page.imagePath],
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (bookmarkedChapters.isEmpty && bookmarkedPages.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No bookmarks yet. Bookmark chapters or pages to see them here.",
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  _bannerAd != null && _isBannerAdLoaded
                      ? SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      )
                      : const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Ad Loading...",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
