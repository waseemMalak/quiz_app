import 'package:flutter/material.dart';

class QuizCompletedDialog extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRestartQuiz;

  const QuizCompletedDialog({
    required this.score,
    required this.totalQuestions,
    required this.onRestartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quiz completed!',
            style: const TextStyle(fontSize: 20, color: Colors.yellow),
          ),
          const SizedBox(height: 20),
          Text(
            'Score: $score / $totalQuestions',
            style: const TextStyle(fontSize: 18, color: Colors.yellow),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRestartQuiz,
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
    );
  }
}
