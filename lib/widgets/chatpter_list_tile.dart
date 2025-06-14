import 'package:education/screens/chapter.dart';
import 'package:flutter/material.dart';

class ChapterTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<String> imagePaths;
  final int chapterNumber;
  final bool isBookmarked;
  final Function(bool)? onBookmarkChanged;

  const ChapterTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imagePaths,
    required this.chapterNumber,
    this.isBookmarked = false,
    this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Chapter(
                  title: title,
                  imagePaths: imagePaths,
                  chapterNumber: chapterNumber,
                ),
          ),
        );
      },
      child: Container(
        height: 90,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
        child: Row(
          children: [
            Image.asset(imagePath, height: 48, width: 48, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE (single line, clipped if too long)
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip, // not ellipsis
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffab77ff),
                minimumSize: const Size(60, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Chapter(
                          title: title,
                          imagePaths: imagePaths,
                          chapterNumber: chapterNumber,
                        ),
                  ),
                );
              },
              child: const Text("Open", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
