import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;

  const QuizPage({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? selectedOption;
  String result = "";

  void submitAnswer() {
    if (selectedOption == widget.correctAnswer) {
      setState(() {
        result = "Correct!";
      });
    } else {
      setState(() {
        result = "Wrong. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Quiz", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffab77ff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...widget.options.map(
              (option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                    result = "";
                  });
                },
              ),
            ),
            ElevatedButton(onPressed: submitAnswer, child: Text("Submit")),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
