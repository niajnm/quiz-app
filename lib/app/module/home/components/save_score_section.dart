// components/save_score_section.dart
import 'package:flutter/material.dart';

class SaveScoreSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;

  const SaveScoreSection({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          '🎉 Quiz Finished! Enter your name to save score:',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Name',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: onSave, child: const Text('Save Score')),
      ],
    );
  }
}
