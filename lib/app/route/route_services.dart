import 'package:flutter/material.dart';

import 'package:quiz/app/route/route_paths.dart';
import 'package:quiz/main.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RoutePaths.home:
        return NoAnimationPageRoute(
          builder: (_) => MyApp(),
          settings: settings,
        );

      // case RoutePaths.detailsPage:
      //   // Check if the arguments are of the correct type (RepositoryEntity)
      //   if (args is RepositoryEntity) {
      //     return NoAnimationPageRoute(
      //       builder: (_) => DetailsPage(repo: args),
      //       settings: settings,
      //     );
      //   } else {
      //     return _errorRoute();
      //   }
      // case RoutePaths.main:
      //   return NoAnimationPageRoute(
      //     builder: (_) => MainView(),
      //     settings: settings,
      //   );

      // case RoutePaths.setting:
      //   return NoAnimationPageRoute(
      //     builder: (_) => SettingPage(),
      //     settings: settings,
      //   );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(appBar: AppBar(title: const Text("Page Not Found")));
      },
    );
  }
}

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
