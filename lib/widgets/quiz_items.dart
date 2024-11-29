import 'package:flutter/material.dart';

class QuizItems extends StatefulWidget {
  const QuizItems({super.key});

  @override
  State<QuizItems> createState() => _QuizItemsState();
}

class _QuizItemsState extends State<QuizItems> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:  EdgeInsets.all(10.0),
      child: Card(child: Column(
        children: [
          Text('quiz topic'),
        ],
      ),),
    );
  }
}