import 'package:flutter/material.dart';

class QuestionOption extends StatefulWidget {
    final Function(String question, List<String> options) onSave;

  const QuestionOption({super.key,required this.onSave});

  @override
  State<QuestionOption> createState() => _QuestionOptionState();
}

class _QuestionOptionState extends State<QuestionOption> {
  final _questionController = TextEditingController();
  final _optionControllers = List.generate(4, (_) => TextEditingController());
  
  @override
  void dispose() {
    // Dispose controllers to free up resources
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
   void _save() {
    final question = _questionController.text;
    final options = _optionControllers.map((controller) => controller.text).toList();

    widget.onSave(question, options);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        controller: _questionController,
        decoration: const InputDecoration(
          hintText: 'Question',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      for (int i = 0; i < _optionControllers.length; i++) ...[
        TextField(
          controller: _optionControllers[i],
          decoration: InputDecoration(
            labelText: 'Option ${i + 1}',
            hintText: 'Enter option ${i + 1}...',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

      ],
      Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _save,
            child: const Text('Save Question'),
          ),
        ),
        const Divider(),
      
    ]);
  }
}
