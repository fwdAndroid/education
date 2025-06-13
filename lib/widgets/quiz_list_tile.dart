import 'package:education/screens/quiz_screen.dart';
import 'package:education/widgets/quiz_widget.dart';
import 'package:flutter/material.dart';

class QuizTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final int chapterNumber;

  const QuizTile({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    bool hasQuiz =
        chapterQuizzes.containsKey(chapterNumber) &&
        chapterQuizzes[chapterNumber]!.isNotEmpty;

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
        child: Padding(
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
                title: Text(title, style: TextStyle(fontSize: 14)),
                subtitle: Row(children: [
                 
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
                            (context) => QuizPage(
                              chapterNumber: chapterNumber,
                              // question: quizData['question'],
                              // options: quizData['options'],
                              // correctAnswer: quizData['correctAnswer'],
                            ),
                      ),
                    );
                  },
                  child: Text("Quiz", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
