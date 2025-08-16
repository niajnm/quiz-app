import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/presentation/components/quiz_header.dart';
import 'package:quiz/app/presentation/view_model/quiz_provider.dart';
import 'package:quiz/app/presentation/view_model/timer_provider.dart';
import '../components/option_tile.dart';
import '../components/question_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: TimerProvider.questionTime),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timer = Provider.of<TimerProvider>(context, listen: false);
      final quiz = Provider.of<QuizProvider>(context, listen: false);

      timer.initAnimationController(_animationController);

      // Set up the time expired callback
      timer.setTimeExpiredCallback(() {
        _onTimeExpired(quiz, timer);
      });

      timer.startTimer();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _onAnswerSelected(int index, QuizProvider quiz, TimerProvider timer) {
    if (quiz.answered) return;
    timer.stopTimer();
    quiz.selectAnswer(index);
  }

  void _onTimeExpired(QuizProvider quiz, TimerProvider timer) {
    if (quiz.answered) return;
    quiz.selectAnswer(-1);
  }

  void _onNextPressed(QuizProvider quiz, TimerProvider timer) {
    quiz.nextQuestion(context);
    if (quiz.currentIndex < quiz.questions.length) {
      timer.startTimer();
    }
  }

  bool _shouldShowSaveScore(QuizProvider quiz) =>
      quiz.answered && quiz.currentIndex == quiz.questions.length - 1;

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuizProvider, TimerProvider>(
      builder: (context, quiz, timer, _) {
        if (quiz.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final question = quiz.questions[quiz.currentIndex];

        return Scaffold(
          appBar: AppBar(centerTitle: true, title: const Text('Quiz')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                QuizHeader(
                  current: quiz.currentIndex + 1,
                  total: quiz.questions.length,
                  progress: 1.0 - (timer.animationController?.value ?? 0),
                  timeLeft: timer.timeLeft,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        QuestionCard(question: question.question),
                        const SizedBox(height: 20),
                        ...List.generate(question.options.length, (i) {
                          return OptionTile(
                            option: question.options[i],
                            isSelected: quiz.selectedAnswer == i,
                            isCorrect: question.answerIndex == i,
                            isAnswered: quiz.answered,
                            onTap: () => _onAnswerSelected(i, quiz, timer),
                          );
                        }),

                        if (quiz.answered)
                          quiz.currentIndex < quiz.questions.length - 1
                              ? const SizedBox.shrink()
                              : _finishQzMsg(),
                      ],
                    ),
                  ),
                ),
                if (quiz.answered)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 88.0),
                    child: ElevatedButton(
                      onPressed: () => _onNextPressed(quiz, timer),
                      child: Text(
                        quiz.currentIndex < quiz.questions.length - 1
                            ? 'Next'
                            : 'Finish',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  _finishQzMsg() => Text(
    '🎉 Quiz Finished! Click finish to save score:',
    style: Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
  );
}
