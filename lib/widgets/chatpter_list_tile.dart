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
    return Container(
      height: 90,
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
      child: Center(
        child: ListTile(
          leading: Image.asset(imagePath),
          subtitle: Text(subtitle),
          title: Text(title, style: TextStyle(fontSize: 14)),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffab77ff),
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
            child: Text("Open", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
