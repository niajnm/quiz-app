// components/option_tile.dart
import 'package:flutter/material.dart';
import 'package:quiz/app/core/utils/math_text_parser.dart';

class OptionTile extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color cardColor = theme.cardColor;

    if (isAnswered) {
      if (isCorrect) cardColor = Colors.green.withOpacity(0.2);
      if (isSelected && !isCorrect) cardColor = Colors.red.withOpacity(0.2);
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isAnswered
                ? (isCorrect
                      ? Colors.green
                      : isSelected
                      ? Colors.red
                      : theme.dividerColor)
                : theme.dividerColor,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: MathTextParser.createMixedContentWidget(
            option,
            textStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
            crossAxisAlignment: WrapCrossAlignment.center,
          ),
        ),
      ),
    );
  }
}
