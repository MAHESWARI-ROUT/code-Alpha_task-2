import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizEvaluation extends StatelessWidget {
  final Map<int, String> selectedOptions;
  final String quizId;

  const QuizEvaluation({required this.selectedOptions, required this.quizId, super.key});

  Future<int> _calculateScore() async {
    final snapshot = await FirebaseFirestore.instance.collection('quizzes').doc(quizId).get();
    final quizData = snapshot.data() as Map<String, dynamic>;
    final questions = quizData['questions'] as List<dynamic>;

    int score = 0;

    for (int i = 0; i < questions.length; i++) {
      final questionData = questions[i] as Map<String, dynamic>;
      final options = questionData['options'] as List<dynamic>;
      final correctAnswer = options.last; // Last option is the correct answer

      if (selectedOptions[i] == correctAnswer) {
        score++;
      }
    }

    return score;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _calculateScore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Evaluation'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Evaluation'),
            ),
            body: Center(
              child: Text('Error calculating score: ${snapshot.error}'),
            ),
          );
        }

        final score = snapshot.data ?? 0;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Evaluation'),
          ),
          body: Center(
            child: Text(
              'Your Score: $score/${selectedOptions.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
