import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  Timer? _timer;
  int _timeLeft = 15;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 15;
    _animationController.reset();
    _animationController.forward();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _timeLeft--);

      if (_timeLeft <= 0) {
        timer.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    final quiz = Provider.of<QuizProvider>(context, listen: false);
    if (!quiz.answered) {
      quiz.selectAnswer(-1); // counts as wrong
    }
  }

  void _onAnswerSelected(int index, QuizProvider quiz) {
    if (quiz.answered) return;

    _timer?.cancel();
    _animationController.stop();
    quiz.selectAnswer(index);
  }

  void _onNextPressed(QuizProvider quiz) {
    quiz.nextQuestion(context);
    if (quiz.currentIndex < quiz.questions.length) {
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Consumer<QuizProvider>(
        builder: (context, quiz, _) {
          if (quiz.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final q = quiz.questions[quiz.currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question header and timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${quiz.currentIndex + 1}/${quiz.questions.length}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    _buildTimer(),
                  ],
                ),
                const SizedBox(height: 8),
                _buildProgressBar(),
                const SizedBox(height: 20),

                // Question text
                Math.tex(q.question, textStyle: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),

                // Options
                ...List.generate(q.options.length, (i) {
                  final selected = quiz.selectedAnswer == i;
                  final correct = q.answerIndex == i;
                  Color color = Colors.blue;

                  if (quiz.answered) {
                    if (correct) color = Colors.green;
                    if (selected && !correct) color = Colors.red;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: color),
                      onPressed: () => _onAnswerSelected(i, quiz),
                      child: Math.tex(
                        q.options[i],
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // Next / Finish button
                if (quiz.answered)
                  ElevatedButton(
                    onPressed: () => _onNextPressed(quiz),
                    child: Text(
                      quiz.currentIndex < quiz.questions.length - 1
                          ? 'Next'
                          : 'Finish',
                    ),
                  ),

                // Quiz finished - enter name
                if (quiz.answered &&
                    quiz.currentIndex == quiz.questions.length - 1) ...[
                  const SizedBox(height: 20),
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

  // Timer display widget
  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _timeLeft <= 5
            ? Colors.red.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _timeLeft <= 5 ? Colors.red : Colors.blue,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 20,
            color: _timeLeft <= 5 ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            '$_timeLeft s',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _timeLeft <= 5 ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  // Animated progress bar
  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: 1.0 - _animationController.value,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            _timeLeft <= 5 ? Colors.red : Colors.blue,
          ),
          minHeight: 4,
        );
      },
    );
  }
}
