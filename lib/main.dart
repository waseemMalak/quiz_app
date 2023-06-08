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

class _QuizPageState extends State<QuizPage> {
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

  void checkAnswer(int selectedIndex) {
    int correctAnswerIndex =
        options[currentQuestionIndex].values.toList().indexOf(0);
    if (selectedIndex == correctAnswerIndex) {
      setState(() {
        score++;
        currentQuestionIndex++;
      });
      _showSnackBar('Correct answer!');
    } else {
      setState(() {
        attempts--;
      });
      if (attempts == 0) {
        _showSnackBar('Wrong answer. No more attempts!');
        currentQuestionIndex++;
      } else {
        _showSnackBar('Wrong answer. $attempts attempts remaining.');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Center(
        child: currentQuestionIndex < questions.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    questions[currentQuestionIndex],
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: List<Widget>.generate(
                      options[currentQuestionIndex].length,
                      (int index) {
                        String option =
                            options[currentQuestionIndex].keys.toList()[index];
                        return ElevatedButton(
                          onPressed: () => checkAnswer(index),
                          child: Text(option),
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
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: $score / ${questions.length}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: restartQuiz,
                    child: const Text('Restart Quiz'),
                  ),
                ],
              ),
      ),
    );
  }
}
