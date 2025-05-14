import 'package:education/chapter.dart';
import 'package:education/learning_dashboard.dart';
import 'package:education/quiz_screen.dart';
import 'package:flutter/material.dart';

class ChapterTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<String> imagePaths;
  final int chapterNumber;

  const ChapterTile({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imagePaths,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasQuiz = chapterQuizzes.containsKey(chapterNumber);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        height: 90,
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
            title: Text(title),
            subtitle: Row(
              children: [
                Text(subtitle),
                if (hasQuiz)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffab77ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onPressed: () {
                        final quizData = chapterQuizzes[chapterNumber]!;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => QuizPage(
                                  question: quizData['question'],
                                  options: quizData['options'],
                                  correctAnswer: quizData['correctAnswer'],
                                ),
                          ),
                        );
                      },
                      child: Text(
                        "Quiz",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
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
                        (context) =>
                            Chapter(title: title, imagePaths: imagePaths),
                  ),
                );
              },
              child: Text("Open", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
