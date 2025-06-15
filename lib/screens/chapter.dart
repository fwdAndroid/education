import 'package:education/constant/ad_keys.dart';
import 'package:education/provider/chapter_provider.dart';
import 'package:education/screens/quiz_dashboard.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => ChapterProvider(imagePaths: imagePaths),
      child: ChapterScreen(
        title: title,
        chapterNumber: chapterNumber,
        imagePaths: imagePaths,
      ),
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
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChapterProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
                MaterialPageRoute(builder: (builder) => const QuizDashboard()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: EnyrptedImageWidget(
                base64Key: base24,
                assetPath: "assets/encrypted/bulb.png.enc",
                width: 50,
                height: 50,
              ),
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
                        imagePath: "assets/encrypted/a.png.enc", // ✅ correct
                        imagePaths: widget.imagePaths,
                      ),
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.7,
            child: PageView.builder(
              controller: PageController(initialPage: provider.currentPage),
              itemCount: provider.imagePaths.length,
              onPageChanged: (index) {
                provider.updatePage(index);
                provider.preloadSurroundingImages(base24);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InteractiveViewer(
                    transformationController: provider.transformationController,
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: EnyrptedImageWidget(
                      base64Key: base24,
                      assetPath: provider.imagePaths[index],
                      height: screenHeight,
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(
            height: screenHeight * 0.04,
            child: Center(
              child: Text(
                '${provider.currentPage + 1}/${provider.imagePaths.length}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),

          SizedBox(
            height: screenHeight * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.zoom_in, color: Colors.black),
                  onPressed: provider.zoomIn,
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out, color: Colors.black),
                  onPressed: provider.zoomOut,
                ),
              ],
            ),
          ),

          SizedBox(
            height: screenHeight * 0.08,
            child:
                provider.isAdLoaded && provider.bannerAd != null
                    ? SizedBox(
                      width: provider.bannerAd!.size.width.toDouble(),
                      height: provider.bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: provider.bannerAd!),
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
