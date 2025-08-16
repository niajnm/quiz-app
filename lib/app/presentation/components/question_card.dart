// components/question_card.dart
import 'package:flutter/material.dart';
import 'package:quiz/app/core/utils/math_text_parser.dart';

class QuestionCard extends StatelessWidget {
  final String question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w400,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: MathTextParser.createMixedContentWidget(
          question,
          textStyle: textStyle,
          crossAxisAlignment: WrapCrossAlignment.center,
        ),
      ),
    );
  }
}
