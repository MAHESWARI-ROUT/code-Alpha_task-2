import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:create_quiz/screens/new_quiz.dart';
import 'package:create_quiz/widgets/quiz_details.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create & Quiz',
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NewQuiz(),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No quizzes available.'));
          }
          final quizzes = snapshot.data!.docs;
          return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                final quizTitle = quiz['title'] as String;
                final quizId = quiz.id;
                return Card(
                  child: ListTile(
                    title: Text(quizTitle),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuizDetailsPage(quizId: quizId),
                        ),
                      );
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}
