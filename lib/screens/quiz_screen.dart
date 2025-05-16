import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/widgets/quiz_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizPage extends StatefulWidget {
  final int chapterNumber;

  const QuizPage({required this.chapterNumber});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with AnalyticsScreenTracker<QuizPage> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int? selectedIndex;

  String get screenName => 'QuizPage${widget.chapterNumber}';

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: bannerKey, // Test Ad Unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    )..load();
  }

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
        title: Text(
          "Chapter ${widget.chapterNumber} Quiz",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xffab77ff),
        iconTheme: IconThemeData(color: Colors.white),
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
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                    _showAnswerDialog(options[value!], correctAnswer);
                  },
                ),
              );
            }),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  _isAdLoaded
                      ? Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      )
                      : Center(
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.block, color: Colors.red, size: 30),
                              Text(
                                "Ad Blocked or Not Loaded",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnswerDialog(String selected, String correct) {
    final isCorrect = selected == correct;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
            content: Text(
              isCorrect
                  ? 'Well done!'
                  : 'Correct answer: $correct\nDo you want to try again?',
            ),
            actions: [
              if (!isCorrect)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    setState(() {
                      selectedIndex = null; // reset selection
                    });
                  },
                  child: Text("Try Again"),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  if (isCorrect) {
                    setState(() {
                      correctAnswers++;
                      if (currentQuestionIndex <
                          chapterQuizzes[widget.chapterNumber]!.length - 1) {
                        currentQuestionIndex++;
                        selectedIndex = null;
                      } else {
                        _showFinalResult();
                      }
                    });
                  } else {
                    // Move forward without reattempt if user doesn't choose Try Again
                    if (currentQuestionIndex <
                        chapterQuizzes[widget.chapterNumber]!.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                        selectedIndex = null;
                      });
                    } else {
                      _showFinalResult();
                    }
                  }
                },
                child: Text(isCorrect ? "Next" : "Skip"),
              ),
            ],
          ),
    );
  }

  void _showFinalResult() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Quiz Complete"),
            content: Text(
              "You got $correctAnswers out of ${chapterQuizzes[widget.chapterNumber]!.length} correct.",
            ),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.popUntil(context, (route) => route.isFirst),
                child: Text("Back to Home"),
              ),
            ],
          ),
    );
  }
}
