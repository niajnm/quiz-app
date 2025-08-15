import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';
import 'package:quiz/main.dart';

class ProviderPath {
  static dynamic providersList = [
    ChangeNotifierProvider(create: (_) => QuizProvider(), child: const MyApp()),

    // ChangeNotifierProvider(create: (_) => HomeController(), lazy: true),
    // ChangeNotifierProvider(create: (_) => BottomNavController(), lazy: true),
    // ChangeNotifierProvider(create: (_) => ThemeController(), lazy: true),
  ];
}
