import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String frontText;
  final String backText;

  const ResultScreen({
    super.key,
    required this.frontText,
    required this.backText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recognition Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Front ID Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(frontText, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text(
              'Back ID Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(backText, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
