import 'package:flutter/material.dart';

class AppThemeData {
  /// Dark theme using Flutter defaults
  static ThemeData getDarkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: _getFont()),
      primaryTextTheme: ThemeData.dark().primaryTextTheme.apply(
        fontFamily: _getFont(),
      ),
    );
  }

  /// Light theme using Flutter defaults
  static ThemeData getLightTheme() {
    return ThemeData.light(useMaterial3: true).copyWith(
      textTheme: ThemeData.light().textTheme.apply(fontFamily: _getFont()),
      primaryTextTheme: ThemeData.light().primaryTextTheme.apply(
        fontFamily: _getFont(),
      ),
    );
  }

  static String _getFont() => 'Roboto'; // replace with your preferred font
}
