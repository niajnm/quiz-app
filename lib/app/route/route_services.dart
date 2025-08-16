import 'package:flutter/material.dart';
import 'package:quiz/app/presentation/view/home_screen.dart';
import 'package:quiz/app/presentation/view/leaderboard_screen.dart';
import 'package:quiz/app/presentation/view/quiz_screen.dart';
import 'package:quiz/app/presentation/view/result_screen.dart';
import 'package:quiz/app/route/route_paths.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case RoutePaths.quiz:
        return MaterialPageRoute(
          builder: (_) => const QuizScreen(),
          settings: settings,
        );

      case RoutePaths.result:
        return MaterialPageRoute(
          builder: (_) => ResultScreen(),
          settings: settings,
        );

      case RoutePaths.leaderboard:
        return MaterialPageRoute(
          builder: (_) => LeaderboardScreen(),
          settings: settings,
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Page Not Found")),
        body: const Center(child: Text("404 - Page Not Found")),
      ),
    );
  }
}
