import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:create_quiz/widgets/question_class.dart';
import 'package:create_quiz/widgets/question_option.dart';
import 'package:flutter/material.dart';
class NewQuiz extends StatefulWidget {
  const NewQuiz({super.key});

  @override
  State<NewQuiz> createState() => _NewQuizState();
}

class _NewQuizState extends State<NewQuiz> {
  final _titleController = TextEditingController();
  final List<Question> _questions = [];
  final List<Widget> _questionOptions = [];
  void _addQuestionOption() {
    setState(() {
      _questionOptions.add( QuestionOption(onSave: (question, options) {
          _saveQuestion(question, options);
        },));
    });
  }
  void _saveQuestion(String question, List<String> options) {
    setState(() {
      _questions.add(Question(questionText: question, options: options));
    });
    print('Saved Question: $question');
    print('Options: $options');
  }
  

 void _saveToFirebase() {
  final quizData = {
    'title': _titleController.text,
    'questions': _questions.map((q) {
      return {
        'questionText': q.questionText,
        'options': q.options,
      };
    }).toList(),
  };

  // Firestore database reference
  FirebaseFirestore.instance
      .collection('quizzes')  // Reference to your 'quizzes' collection
      .add(quizData)  // Add a new document with the quiz data
      .then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz saved successfully!')),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving quiz: $error')),
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter topic name....',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            
            Expanded(
                child: ListView(
              children: _questionOptions,
            )),
            ElevatedButton(onPressed: _saveToFirebase, child: const Text('Save')),
            Row(
              children: [
                const Spacer(),
                FloatingActionButton(
                  onPressed: _addQuestionOption,
                  child: const Icon(Icons.add),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
