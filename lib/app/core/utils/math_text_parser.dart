// utils/math_text_parser.dart
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Utility class for parsing and rendering mixed text and LaTeX math content
class MathTextParser {
  static const List<String> _mathCommands = [
    r'\int',
    r'\frac',
    r'\sum',
    r'\prod',
    r'\sqrt',
    r'\lim',
    r'\sin',
    r'\cos',
    r'\tan',
    r'\log',
    r'\ln',
    r'\sec',
    r'\csc',
    r'\cot',
    r'\alpha',
    r'\beta',
    r'\gamma',
    r'\delta',
    r'\epsilon',
    r'\zeta',
    r'\eta',
    r'\theta',
    r'\iota',
    r'\kappa',
    r'\lambda',
    r'\mu',
    r'\nu',
    r'\xi',
    r'\pi',
    r'\rho',
    r'\sigma',
    r'\tau',
    r'\upsilon',
    r'\phi',
    r'\chi',
    r'\psi',
    r'\omega',
    r'\infty',
    r'\partial',
    r'\nabla',
    r'\pm',
    r'\mp',
    r'\times',
    r'\div',
    r'\cdot',
    r'\bullet',
    r'\leq',
    r'\geq',
    r'\neq',
    r'\approx',
    r'\equiv',
    r'\propto',
    r'\in',
    r'\notin',
    r'\subset',
    r'\supset',
    r'\subseteq',
    r'\supseteq',
    r'\cup',
    r'\cap',
    r'\left',
    r'\right',
    r'\begin',
    r'\end',
  ];

  /// Check if text contains LaTeX math expressions
  static bool containsMath(String text) {
    for (String command in _mathCommands) {
      if (text.contains(command)) return true;
    }
    return text.contains(RegExp(r'[_^]'));
  }

  /// Parse mixed content and return list of widgets
  static List<Widget> parseToWidgets(String text, {TextStyle? textStyle}) {
    if (!containsMath(text)) {
      return [Text(text, style: textStyle)];
    }

    List<Widget> widgets = [];
    int position = 0;
    String currentText = '';

    while (position < text.length) {
      if (text[position] == '\\') {
        String mathExpression = _extractMathExpression(text, position);

        if (mathExpression.isNotEmpty) {
          // Add accumulated text
          if (currentText.isNotEmpty) {
            widgets.add(Text(currentText, style: textStyle));
            currentText = '';
          }

          // Add math expression
          widgets.add(_createMathWidget(mathExpression, textStyle));
          position += mathExpression.length;
        } else {
          currentText += text[position];
          position++;
        }
      } else {
        currentText += text[position];
        position++;
      }
    }

    // Add remaining text
    if (currentText.isNotEmpty) {
      widgets.add(Text(currentText, style: textStyle));
    }

    return widgets.isEmpty ? [Text(text, style: textStyle)] : widgets;
  }

  /// Create a widget that handles mixed text and math content
  static Widget createMixedContentWidget(
    String text, {
    TextStyle? textStyle,
    WrapAlignment alignment = WrapAlignment.start,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.center,
  }) {
    List<Widget> widgets = parseToWidgets(text, textStyle: textStyle);

    if (widgets.length == 1) {
      return widgets.first;
    }

    return Wrap(
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: widgets,
    );
  }

  /// Extract a complete math expression starting from given position
  static String _extractMathExpression(String text, int start) {
    if (start >= text.length || text[start] != '\\') {
      return '';
    }

    // Find matching math command
    String foundCommand = '';
    for (String command in _mathCommands) {
      if (text.substring(start).startsWith(command)) {
        foundCommand = command;
        break;
      }
    }

    if (foundCommand.isEmpty) return '';

    int position = start + foundCommand.length;
    String mathExpression = foundCommand;

    // Parse arguments, subscripts, and superscripts
    while (position < text.length) {
      if (text[position] == '_' || text[position] == '^') {
        mathExpression += text[position];
        position++;
        position = _parseScriptOrArgument(text, position, mathExpression);
        mathExpression = _getUpdatedExpression(text, start, position);
      } else if (text[position] == '{') {
        position = _parseArgument(text, position, mathExpression);
        mathExpression = _getUpdatedExpression(text, start, position);
      } else if (_isValidMathCharacter(text[position])) {
        mathExpression += text[position];
        position++;
      } else {
        break;
      }
    }

    return mathExpression;
  }

  static int _parseScriptOrArgument(
    String text,
    int position,
    String mathExpression,
  ) {
    if (position >= text.length) return position;

    if (text[position] == '{') {
      return _parseArgument(text, position, mathExpression);
    } else {
      // Single character subscript/superscript
      return position + 1;
    }
  }

  static int _parseArgument(String text, int position, String mathExpression) {
    if (position >= text.length || text[position] != '{') return position;

    int braceCount = 1;
    position++; // Skip opening brace

    while (position < text.length && braceCount > 0) {
      if (text[position] == '{') braceCount++;
      if (text[position] == '}') braceCount--;
      position++;
    }

    return position;
  }

  static String _getUpdatedExpression(String text, int start, int end) {
    return text.substring(start, end);
  }

  static bool _isValidMathCharacter(String char) {
    return RegExp(r'[a-zA-Z0-9\s]').hasMatch(char);
  }

  static Widget _createMathWidget(String mathExpression, TextStyle? textStyle) {
    try {
      return Math.tex(mathExpression, textStyle: textStyle);
    } catch (e) {
      // Fallback to regular text if LaTeX parsing fails
      return Text(mathExpression, style: textStyle);
    }
  }
}
