import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  bool get isDarkMode => (Theme.of(this).brightness == Brightness.dark);

  void showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(this).snackBarTheme.backgroundColor,
        content: Text(errorMessage),
      ),
    );
  }
}
