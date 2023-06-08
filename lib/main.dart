import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  List<String> questions = [
    'Question 1: What is the capital of France?',
    'Question 2: Who painted the Mona Lisa?',
    'Question 3: What is the largest planet in our solar system?'
  ];

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      attempts = 3;
    });
  }

  List<Map<String, int>> options = [
    {'Paris': 0, 'London': 1, 'Rome': 1},
    {'Leonardo da Vinci': 0, 'Pablo Picasso': 1, 'Vincent van Gogh': 1},
    {'Jupiter': 0, 'Saturn': 1, 'Neptune': 1}
  ];

  int currentQuestionIndex = 0;
  int score = 0;
  int attempts = 3;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear, // Use linear curve for continuous looping
      ),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void checkAnswer(int selectedIndex) {
    int correctAnswerIndex =
        options[currentQuestionIndex].values.toList().indexOf(0);
    if (selectedIndex == correctAnswerIndex) {
      setState(() {
        score++;
        currentQuestionIndex++;
      });
      _showDialogWithAnimation('Correct answer!');
    } else {
      setState(() {
        attempts--;
        if (attempts == 0) {
          _showDialogWithAnimation('Wrong answer. No more attempts!');
          currentQuestionIndex++;
          attempts = 3; // Reset attempts for the next question
        } else {
          _showDialogWithAnimation(
              'Wrong answer. $attempts attempts remaining.');
        }
      });
    }
  }

  void _showDialogWithAnimation(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go To Next Question'),
                ),
              ],
            ),
          ),
        );
      },
    );
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow[700]!, Colors.yellow[900]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: const Text('Quiz App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.black87,
              Colors.grey,
              const Color(0xFFFFD700)
            ], // Black, Gray, Gold
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: currentQuestionIndex < questions.length
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      questions[currentQuestionIndex],
                      style:
                          const TextStyle(fontSize: 20, color: Colors.yellow),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: List<Widget>.generate(
                        options[currentQuestionIndex].length,
                        (int index) {
                          String option = options[currentQuestionIndex]
                              .keys
                              .toList()[index];
                          return ElevatedButton(
                            onPressed: () => checkAnswer(index),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFFFD700), // Gold color
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Quiz completed!',
                      style:
                          const TextStyle(fontSize: 20, color: Colors.yellow),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Score: $score / ${questions.length}',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.yellow),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: restartQuiz,
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFFFD700), // Gold color
                      ),
                      child: const Text(
                        'Restart Quiz',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
