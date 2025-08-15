// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:quiz/app/data/local/question_local/questions_local_source.dart';
// // import 'package:quiz/app/data/repository/questions_repository_source.dart';
// // import 'package:quiz/app/module/home/model/model.dart';
// // import 'package:quiz/app/utils/core/services/service_locator.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:flutter/services.dart';

// // class QuizProvider with ChangeNotifier {
// //   final QuestionRepositorySource _questionSource =
// //       serviceLocator<QuestionRepositorySource>();
// //   List<Question> _questions = [];
// //   int _currentIndex = 0;
// //   int _score = 0;
// //   bool _answered = false;
// //   int? _selectedAnswer;

// //   List<Map<String, dynamic>> _leaderboard = [];

// //   List<Question> get questions => _questions;
// //   int get currentIndex => _currentIndex;
// //   int get score => _score;
// //   bool get answered => _answered;
// //   int? get selectedAnswer => _selectedAnswer;
// //   List<Map<String, dynamic>> get leaderboard => _leaderboard;

// //   Future<void> loadQuestions() async {
// //     final data = await _questionSource.fetchQuestionsGet(0);

// //     // rootBundle.loadString('assets/questions.json');
// //     // final jsonData = json.decode(data) as List;
// //     // _questions = jsonData.map((q) => Question.fromJson(q)).toList();
// //     _questions = data;

// //     notifyListeners();
// //   }

// //   void selectAnswer(int index) {
// //     if (_answered) return;
// //     _selectedAnswer = index;
// //     _answered = true;
// //     if (_questions[_currentIndex].answerIndex == index) _score++;
// //     notifyListeners();
// //   }

// //   void nextQuestion(BuildContext context) {
// //     if (_currentIndex < _questions.length - 1) {
// //       _currentIndex++;
// //       _answered = false;
// //       _selectedAnswer = null;
// //     } else {
// //       // Quiz finished: navigate to ResultScreen
// //       Navigator.pushReplacementNamed(context, '/result');
// //     }
// //     notifyListeners();
// //   }

// //   Future<void> saveScore(String name) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _leaderboard =
// //         prefs
// //             .getStringList('leaderboard')
// //             ?.map((e) => json.decode(e) as Map<String, dynamic>)
// //             .toList() ??
// //         [];
// //     _leaderboard.add({"name": name, "score": _score});
// //     _leaderboard.sort((a, b) => b["score"].compareTo(a["score"]));
// //     await prefs.setStringList(
// //       'leaderboard',
// //       _leaderboard.map((e) => json.encode(e)).toList(),
// //     );
// //   }

// //   Future<void> loadLeaderboard() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _leaderboard =
// //         prefs
// //             .getStringList('leaderboard')
// //             ?.map((e) => json.decode(e) as Map<String, dynamic>)
// //             .toList() ??
// //         [];
// //     notifyListeners();
// //   }

// //   void resetQuiz() {
// //     _currentIndex = 0;
// //     _score = 0;
// //     _answered = false;
// //     _selectedAnswer = null;
// //     notifyListeners();
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:quiz/app/data/local/question_local/questions_local_source.dart';
// import 'package:quiz/app/data/repository/questions_repository_source.dart';
// import 'package:quiz/app/module/home/model/model.dart';
// import 'package:quiz/app/utils/core/services/service_locator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';

// class QuizProvider with ChangeNotifier {
//   final QuestionRepositorySource _questionSource =
//       serviceLocator<QuestionRepositorySource>();
//   List<Question> _questions = [];
//   int _currentIndex = 0;
//   int _score = 0;
//   bool _answered = false;
//   int? _selectedAnswer;

//   List<Map<String, dynamic>> _leaderboard = [];

//   List<Question> get questions => _questions;
//   int get currentIndex => _currentIndex;
//   int get score => _score;
//   bool get answered => _answered;
//   int? get selectedAnswer => _selectedAnswer;
//   List<Map<String, dynamic>> get leaderboard => _leaderboard;

//   Future<void> loadQuestions() async {
//     final data = await _questionSource.fetchQuestionsGet(0);

//     // rootBundle.loadString('assets/questions.json');
//     // final jsonData = json.decode(data) as List;
//     // _questions = jsonData.map((q) => Question.fromJson(q)).toList();
//     _questions = data;

//     notifyListeners();
//   }

//   void selectAnswer(int index) {
//     if (_answered) return;
//     _selectedAnswer = index;
//     _answered = true;
//     if (_questions[_currentIndex].answerIndex == index) _score++;
//     notifyListeners();
//   }

//   void nextQuestion(BuildContext context) {
//     if (_currentIndex < _questions.length - 1) {
//       _currentIndex++;
//       _answered = false;
//       _selectedAnswer = null;
//     } else {
//       // Quiz finished: navigate to ResultScreen
//       Navigator.pushReplacementNamed(context, '/result');
//     }
//     notifyListeners();
//   }

//   Future<void> saveScore(String name) async {
//     final prefs = await SharedPreferences.getInstance();
//     _leaderboard =
//         prefs
//             .getStringList('leaderboard')
//             ?.map((e) => json.decode(e) as Map<String, dynamic>)
//             .toList() ??
//         [];
//     _leaderboard.add({"name": name, "score": _score});
//     _leaderboard.sort((a, b) => b["score"].compareTo(a["score"]));
//     await prefs.setStringList(
//       'leaderboard',
//       _leaderboard.map((e) => json.encode(e)).toList(),
//     );
//   }

//   Future<void> loadLeaderboard() async {
//     final prefs = await SharedPreferences.getInstance();
//     _leaderboard =
//         prefs
//             .getStringList('leaderboard')
//             ?.map((e) => json.decode(e) as Map<String, dynamic>)
//             .toList() ??
//         [];
//     notifyListeners();
//   }

//   void resetQuiz() {
//     _currentIndex = 0;
//     _score = 0;
//     _answered = false;
//     _selectedAnswer = null;
//     notifyListeners();
//   }
// }

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

// class _QuizScreenState extends State<QuizScreen> {
//   final TextEditingController nameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quiz')),
//       body: Consumer<QuizProvider>(
//         builder: (context, quiz, _) {
//           if (quiz.questions.isEmpty)
//             return const Center(child: CircularProgressIndicator());

//           final q = quiz.questions[quiz.currentIndex];

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Question ${quiz.currentIndex + 1}/${quiz.questions.length}',
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 20),
//                 Math.tex(q.question, textStyle: const TextStyle(fontSize: 24)),
//                 const SizedBox(height: 20),
//                 ...List.generate(q.options.length, (i) {
//                   final selected = quiz.selectedAnswer == i;
//                   final correct = q.answerIndex == i;
//                   Color color = Colors.blue;
//                   if (quiz.answered) {
//                     if (selected && correct) color = Colors.green;
//                     if (selected && !correct) color = Colors.red;
//                   }

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 6),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: color),
//                       onPressed: () => quiz.selectAnswer(i),
//                       child: Math.tex(
//                         q.options[i],
//                         textStyle: const TextStyle(fontSize: 20),
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 20),

//                 // Next button if not last question
//                 if (quiz.answered)
//                   ElevatedButton(
//                     onPressed: () => quiz.nextQuestion(context),
//                     child: Text(
//                       quiz.currentIndex < quiz.questions.length - 1
//                           ? 'Next'
//                           : 'Finish',
//                     ),
//                   ),

//                 // Last question finished
//                 if (quiz.answered &&
//                     quiz.currentIndex == quiz.questions.length - 1) ...[
//                   const Text(
//                     'Quiz Finished! Enter your name to save score:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Your Name',
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       final name = nameController.text.trim();
//                       if (name.isNotEmpty) {
//                         quiz.saveScore(name);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Score saved!')),
//                         );
//                       }
//                     },
//                     child: const Text('Save Score'),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
