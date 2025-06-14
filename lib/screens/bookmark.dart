import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/chapter.dart';
import 'package:education/screens/learning_dashboard.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/widgets/chatpter_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  @override
  void initState() {
    super.initState();
    _loadBannerAd();
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
    final bookmarkService = BookmarkService();

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
              child: Image.asset("assets/raw/bulb.png", height: 50, width: 50),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => LearningDashboard()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/raw/Screenshot 2025-05-23 115139.png",
                height: 50,
                width: 50,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Bookmark", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffab77ff),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (bookmarkService.bookmarkedChapters.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Bookmarked Chapters",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ...bookmarkService.bookmarkedChapters.map((chapter) {
              return ChapterTile(
                title: chapter.title,
                subtitle: chapter.subtitle,
                imagePath: chapter.imagePath,
                imagePaths: chapter.imagePaths,
                chapterNumber: chapter.chapterNumber,
                isBookmarked: true,
                onBookmarkChanged: (isBookmarked) {
                  setState(() {
                    if (!isBookmarked) {
                      bookmarkService.removeChapterBookmark(
                        chapter.chapterNumber,
                      );
                    }
                  });
                },
              );
            }).toList(),
            if (bookmarkService.bookmarkedPages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Bookmarked Pages",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ...bookmarkService.bookmarkedPages.map((page) {
              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Image.asset(page.imagePath, width: 50, height: 50),
                  title: Text(
                    "${page.chapterTitle} - Page ${page.pageNumber + 1}",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.bookmark, color: Colors.purple),
                    onPressed: () {
                      setState(() {
                        bookmarkService.removePageBookmark(
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
                            (context) => Chapter(
                              chapterNumber: page.chapterNumber,
                              title: page.chapterTitle,
                              imagePaths: [page.imagePath],
                            ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
            if (bookmarkService.bookmarkedChapters.isEmpty &&
                bookmarkService.bookmarkedPages.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No bookmarks yet. Bookmark chapters or pages to see them here.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
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
    );
  }
}
