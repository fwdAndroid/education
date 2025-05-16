import 'package:education/widgets/quiz_widget.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final int chapterNumber;

  const QuizPage({required this.chapterNumber});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  bool isAnswered = false;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final quizzes = chapterQuizzes[widget.chapterNumber];
    if (quizzes == null || quizzes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz")),
        body: Center(child: Text("No quizzes available.")),
      );
    }

    final currentQuiz = quizzes[currentQuestionIndex];
    final question = currentQuiz['question'] as String;
    final options = currentQuiz['options'] as List<String>;
    final correctAnswer = currentQuiz['correctAnswer'] as String;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Chapter ${widget.chapterNumber} Quiz",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xffab77ff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${currentQuestionIndex + 1}: $question",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ...List.generate(options.length, (index) {
              return ListTile(
                title: Text(options[index]),
                leading: Radio<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged:
                      isAnswered
                          ? null
                          : (value) {
                            setState(() {
                              selectedIndex = value;
                              isAnswered = true;

                              final isCorrect =
                                  options[value!] == correctAnswer;
                              if (isCorrect) correctAnswers++;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isCorrect
                                        ? 'Correct!'
                                        : 'Wrong! Correct answer: $correctAnswer',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });
                          },
                ),
              );
            }),
            SizedBox(height: 20),
            if (isAnswered)
              Center(
                child: ElevatedButton(
                  child: Text(
                    currentQuestionIndex < quizzes.length - 1
                        ? 'Next Question'
                        : 'Finish Quiz',
                  ),
                  onPressed: () {
                    if (currentQuestionIndex < quizzes.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                        selectedIndex = null;
                        isAnswered = false;
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: Text('Quiz Complete'),
                              content: Text(
                                'You got $correctAnswers out of ${quizzes.length} correct.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.popUntil(
                                        context,
                                        (route) => route.isFirst,
                                      ),
                                  child: Text('Back to Home'),
                                ),
                              ],
                            ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
