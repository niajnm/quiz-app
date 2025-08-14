import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';
import '../providers/quiz_provider.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Consumer<QuizProvider>(
        builder: (context, quiz, _) {
          if (quiz.questions.isEmpty)
            return const Center(child: CircularProgressIndicator());

          final q = quiz.questions[quiz.currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${quiz.currentIndex + 1}/${quiz.questions.length}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Math.tex(q.question, textStyle: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                ...List.generate(q.options.length, (i) {
                  final selected = quiz.selectedAnswer == i;
                  final correct = q.answerIndex == i;
                  Color color = Colors.blue;
                  if (quiz.answered) {
                    if (selected && correct) color = Colors.green;
                    if (selected && !correct) color = Colors.red;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: color),
                      onPressed: () => quiz.selectAnswer(i),
                      child: Math.tex(
                        q.options[i],
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // Next button if not last question
                if (quiz.answered)
                  ElevatedButton(
                    onPressed: () => quiz.nextQuestion(context),
                    child: Text(
                      quiz.currentIndex < quiz.questions.length - 1
                          ? 'Next'
                          : 'Finish',
                    ),
                  ),

                // Last question finished
                if (quiz.answered &&
                    quiz.currentIndex == quiz.questions.length - 1) ...[
                  const Text(
                    'Quiz Finished! Enter your name to save score:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        quiz.saveScore(name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Score saved!')),
                        );
                      }
                    },
                    child: const Text('Save Score'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
