import 'package:education/constant/ad_keys.dart';
import 'package:education/screens/quiz/quiz_screen.dart';
import 'package:education/utils_colors/colors.dart';
import 'package:education/widgets/enyrpted_image_widget.dart';
import 'package:flutter/material.dart';

class QuizTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final int chapterNumber;

  const QuizTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => QuizPage(
                    chapterNumber: chapterNumber,
                    // question: quizData['question'],
                    // options: quizData['options'],
                    // correctAnswer: quizData['correctAnswer'],
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
            color: white,
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              EnyrptedImageWidget(
                assetPath: imagePath,
                height: 48,
                width: 48,
                base64Key: base24,
              ),
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
                    Text(subtitle, style: TextStyle(fontSize: 12, color: grey)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
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
                          (context) => QuizPage(chapterNumber: chapterNumber),
                    ),
                  );
                },
                child: Text("Open", style: TextStyle(color: white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
