import 'package:education/utils_colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:confetti/confetti.dart';
import 'package:education/constant/ad_keys.dart';
import 'package:education/mixin/firebase_analytics_mixin.dart';
import 'package:education/screens/quiz/quiz_widget.dart';

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

  late ConfettiController _confettiController;
  bool showConfetti = false;

  String get screenName => 'QuizPage${widget.chapterNumber}';

  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _confettiController.dispose();
    super.dispose();
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
      bottomNavigationBar: BottomAppBar(
        color: transparent,
        elevation: 0,
        child:
            _isBannerAdLoaded && _bannerAd != null
                ? Container(
                  alignment: Alignment.center,
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
                : const SizedBox(
                  height: 50,
                  child: Center(child: Text("Ad loading...")),
                ),
      ),
      appBar: AppBar(
        title: Text(
          "Chapter ${widget.chapterNumber} Quiz",
          style: TextStyle(color: white),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: white),
      ),
      body: Column(
        children: [
          if (showConfetti)
            SizedBox(
              height: 100,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [Colors.deepPurple, Colors.pink, Colors.orange],
              ),
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Padding(
                key: ValueKey(currentQuestionIndex),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            "${currentQuestionIndex + 1}",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ...List.generate(options.length, (index) {
                      final isSelected = selectedIndex == index;

                      return AnimatedContainer(
                        width: MediaQuery.of(context).size.width * 1,
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.deepPurple
                                    : Colors.grey.shade400,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color:
                              isSelected
                                  ? Colors.deepPurple.withOpacity(0.1)
                                  : white,
                        ),
                        child: Material(
                          color: transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              _showAnswerDialog(options[index], correctAnswer);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(14),
                              child: Text(
                                options[index],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                    Navigator.pop(context);
                    setState(() {
                      selectedIndex = null;
                    });
                  },
                  child: Text("Try Again"),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isCorrect) {
                    setState(() {
                      correctAnswers++;
                      if (currentQuestionIndex <
                          chapterQuizzes[widget.chapterNumber]!.length - 1) {
                        currentQuestionIndex++;
                        selectedIndex = null;
                      } else {
                        _triggerConfettiAndShowResult();
                      }
                    });
                  } else {
                    if (currentQuestionIndex <
                        chapterQuizzes[widget.chapterNumber]!.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                        selectedIndex = null;
                      });
                    } else {
                      _triggerConfettiAndShowResult();
                    }
                  }
                },
                child: Text(isCorrect ? "Next" : "Skip"),
              ),
            ],
          ),
    );
  }

  void _triggerConfettiAndShowResult() {
    setState(() {
      showConfetti = true;
    });
    _confettiController.play();
    Future.delayed(Duration(seconds: 2), () {
      _showFinalResult();
    });
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
