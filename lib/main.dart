import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/home_screen.dart';
import 'package:quiz/app/module/home/quiz_screen.dart';
import 'package:quiz/app/module/home/result_screen.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => QuizProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/quiz': (_) => const QuizScreen(),
        '/result': (_) => ResultScreen(),
      },
    );
  }
}
