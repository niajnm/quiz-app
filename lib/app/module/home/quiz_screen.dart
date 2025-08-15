// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:provider/provider.dart';
// import 'package:quiz/app/module/home/view_model/quiz_provider.dart';
// import 'result_screen.dart';

// class QuizScreen extends StatefulWidget {
//   const QuizScreen({super.key});

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
//   final TextEditingController nameController = TextEditingController();
//   Timer? _timer;
//   int _timeLeft = 15;
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 15),
//       vsync: this,
//     );
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _animationController.dispose();
//     nameController.dispose();
//     super.dispose();
//   }

//   void _startTimer() {
//     _timeLeft = 15;
//     _animationController.reset();
//     _animationController.forward();

//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() => _timeLeft--);
//       if (_timeLeft <= 0) {
//         timer.cancel();
//         _handleTimeUp();
//       }
//     });
//   }

//   void _handleTimeUp() {
//     final quiz = context.read<QuizProvider>();
//     if (!quiz.answered) {
//       quiz.selectAnswer(-1);
//     }
//   }

//   void _onAnswerSelected(int index, QuizProvider quiz) {
//     if (quiz.answered) return;
//     _timer?.cancel();
//     _animationController.stop();
//     quiz.selectAnswer(index);
//   }

//   void _onNextPressed(QuizProvider quiz) {
//     quiz.nextQuestion(context);
//     if (quiz.currentIndex < quiz.questions.length) {
//       _startTimer();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Quiz'), centerTitle: true),
//       body: Consumer<QuizProvider>(
//         builder: (context, quiz, _) {
//           if (quiz.questions.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final q = quiz.questions[quiz.currentIndex];

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Header with timer
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Question ${quiz.currentIndex + 1}/${quiz.questions.length}',
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     _buildTimerCircle(),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 _buildProgressBar(),
//                 const SizedBox(height: 20),

//                 // Scrollable Question + Options
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // Question Card
//                         Card(
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: Math.tex(
//                               q.question,
//                               //  textAlign: TextAlign.center,
//                               textStyle: theme.textTheme.titleSmall?.copyWith(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Options
//                         ...List.generate(q.options.length, (i) {
//                           final selected = quiz.selectedAnswer == i;
//                           final correct = q.answerIndex == i;

//                           Color cardColor = theme.cardColor;
//                           if (quiz.answered) {
//                             if (correct)
//                               cardColor = Colors.green.withOpacity(0.2);
//                             if (selected && !correct) {
//                               cardColor = Colors.red.withOpacity(0.2);
//                             }
//                           }

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 6),
//                             child: GestureDetector(
//                               onTap: () => _onAnswerSelected(i, quiz),
//                               child: Card(
//                                 color: cardColor,
//                                 elevation: 2,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   side: BorderSide(
//                                     color: quiz.answered
//                                         ? (correct
//                                               ? Colors.green
//                                               : selected
//                                               ? Colors.red
//                                               : theme.dividerColor)
//                                         : theme.dividerColor,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                     horizontal: 16,
//                                   ),
//                                   child: Math.tex(
//                                     q.options[i],
//                                     textStyle: theme.textTheme.bodyLarge
//                                         ?.copyWith(fontSize: 18),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),

//                         const SizedBox(height: 20),

//                         // Name input when finished
//                         if (quiz.answered &&
//                             quiz.currentIndex == quiz.questions.length - 1) ...[
//                           const SizedBox(height: 20),
//                           Text(
//                             '🎉 Quiz Finished! Enter your name to save score:',
//                             style: theme.textTheme.bodyLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 10),
//                           TextField(
//                             controller: nameController,
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: 'Your Name',
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               final name = nameController.text.trim();
//                               if (name.isNotEmpty) {
//                                 quiz.saveScore(name);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('Score saved!')),
//                                 );
//                               }
//                             },
//                             child: const Text('Save Score'),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // Next / Finish Button
//                 if (quiz.answered)
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           quiz.currentIndex < quiz.questions.length - 1
//                           ? Colors.blue
//                           : Colors.orange,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () => _onNextPressed(quiz),
//                     child: Text(
//                       quiz.currentIndex < quiz.questions.length - 1
//                           ? 'Next'
//                           : 'Finish',
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// Circular Timer
//   Widget _buildTimerCircle() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         SizedBox(
//           height: 40,
//           width: 40,
//           child: CircularProgressIndicator(
//             value: 1.0 - _animationController.value,
//             backgroundColor: Colors.grey.shade300,
//             valueColor: AlwaysStoppedAnimation<Color>(
//               _timeLeft <= 5 ? Colors.red : Colors.blue,
//             ),
//             strokeWidth: 4,
//           ),
//         ),
//         Text(
//           '$_timeLeft',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: _timeLeft <= 5 ? Colors.red : Colors.blue,
//           ),
//         ),
//       ],
//     );
//   }

//   /// Progress Bar
//   Widget _buildProgressBar() {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return LinearProgressIndicator(
//           value: 1.0 - _animationController.value,
//           backgroundColor: Colors.grey.shade300,
//           valueColor: AlwaysStoppedAnimation<Color>(
//             _timeLeft <= 5 ? Colors.red : Colors.blue,
//           ),
//           minHeight: 6,
//         );
//       },
//     );
//   }
// }

// quiz_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/components/quiz_header.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';
import 'package:quiz/app/module/home/view_model/timer_provider.dart';

import 'components/timer_circle.dart';
import 'components/quiz_progress_bar.dart';
import 'components/question_card.dart';
import 'components/option_tile.dart';
import 'components/save_score_section.dart';

// class QuizScreen extends StatefulWidget {
//   const QuizScreen({super.key});

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
//   static const int _questionTime = 15;

//   final TextEditingController nameController = TextEditingController();
//   late final AnimationController _animationController;
//   Timer? _timer;
//   int _timeLeft = _questionTime;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: _questionTime),
//       vsync: this,
//     );
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _animationController.dispose();
//     nameController.dispose();
//     super.dispose();
//   }

//   void _startTimer() {
//     setState(() => _timeLeft = _questionTime);
//     _animationController
//       ..reset()
//       ..forward();

//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() => _timeLeft--);
//       if (_timeLeft <= 0) {
//         timer.cancel();
//         _handleTimeUp();
//       }
//     });
//   }

//   void _handleTimeUp() {
//     final quiz = context.read<QuizProvider>();
//     if (!quiz.answered) quiz.selectAnswer(-1);
//   }

//   void _onAnswerSelected(int index, QuizProvider quiz) {
//     if (quiz.answered) return;
//     _timer?.cancel();
//     _animationController.stop();
//     quiz.selectAnswer(index);
//   }

//   void _onNextPressed(QuizProvider quiz) {
//     quiz.nextQuestion(context);
//     if (quiz.currentIndex < quiz.questions.length) _startTimer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true, title: const Text('Quiz')),
//       body: Consumer<QuizProvider>(
//         builder: (context, quiz, _) {
//           if (quiz.questions.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final question = quiz.questions[quiz.currentIndex];

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _QuizHeader(
//                   current: quiz.currentIndex + 1,
//                   total: quiz.questions.length,
//                   progress: 1.0 - _animationController.value,
//                   timeLeft: _timeLeft,
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         QuestionCard(question: question.question),
//                         const SizedBox(height: 20),
//                         ...List.generate(question.options.length, (i) {
//                           return OptionTile(
//                             option: question.options[i],
//                             isSelected: quiz.selectedAnswer == i,
//                             isCorrect: question.answerIndex == i,
//                             isAnswered: quiz.answered,
//                             onTap: () => _onAnswerSelected(i, quiz),
//                           );
//                         }),
//                         if (_shouldShowSaveScore(quiz))
//                           SaveScoreSection(
//                             controller: nameController,
//                             onSave: () {
//                               final name = nameController.text.trim();
//                               if (name.isNotEmpty) {
//                                 quiz.saveScore(name);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('Score saved!')),
//                                 );
//                               }
//                             },
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (quiz.answered)
//                   ElevatedButton(
//                     onPressed: () => _onNextPressed(quiz),
//                     child: Text(
//                       quiz.currentIndex < quiz.questions.length - 1
//                           ? 'Next'
//                           : 'Finish',
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   bool _shouldShowSaveScore(QuizProvider quiz) =>
//       quiz.answered && quiz.currentIndex == quiz.questions.length - 1;
// }

// class _QuizHeader extends StatelessWidget {
//   final int current;
//   final int total;
//   final double progress;
//   final int timeLeft;

//   const _QuizHeader({
//     required this.current,
//     required this.total,
//     required this.progress,
//     required this.timeLeft,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Question $current/$total'),
//             TimerCircle(progress: progress, timeLeft: timeLeft),
//           ],
//         ),
//         const SizedBox(height: 8),
//         QuizProgressBar(progress: progress, isTimeLow: timeLeft <= 5),
//       ],
//     );
//   }
// }

//33333|
// your TimerProvider

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
      timer.initAnimationController(_animationController);
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
                        if (_shouldShowSaveScore(quiz))
                          SaveScoreSection(
                            controller: nameController,
                            onSave: () {
                              final name = nameController.text.trim();
                              if (name.isNotEmpty) {
                                quiz.saveScore(name);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Score saved!')),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                if (quiz.answered)
                  ElevatedButton(
                    onPressed: () => _onNextPressed(quiz, timer),
                    child: Text(
                      quiz.currentIndex < quiz.questions.length - 1
                          ? 'Next'
                          : 'Finish',
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
