import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:create_quiz/screens/quiz_evaluation.dart';
import 'package:flutter/material.dart';

class QuizDetailsPage extends StatefulWidget {
  final String quizId; // Document ID passed from the homepage

  const QuizDetailsPage({required this.quizId, super.key});

  @override
  State<QuizDetailsPage> createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  final Map<int, String> _selectedOptions = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Quiz not found.'));
          }

          final quizData = snapshot.data!.data() as Map<String, dynamic>;
          print('Quiz Data: $quizData');
          final questions = quizData['questions'] as List<dynamic>;

          if (questions.isEmpty) {
            return const Center(child: Text('No questions available.'));
          }

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final questionData = questions[index] as Map<String, dynamic>;
              final questionText =
                  questionData['questionText'] as String? ?? 'No question text';
              final options = questionData['options'] as List<dynamic>? ?? [];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q${index + 1}: $questionText',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ...options.take(3).map((option) {
                      final isSelected = _selectedOptions[index] == option;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOptions[index] = option;
                          });
                        },
                        child: Center(
                          child: Card(
                            color: isSelected ? Colors.blue : Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  ' $option',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QuizEvaluation(selectedOptions: _selectedOptions, quizId: widget.quizId)));
                      },
                      child: Text('Submit'),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
