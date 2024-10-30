import 'package:flutter/material.dart';

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  ReportBugPageState createState() => ReportBugPageState();
}

class ReportBugPageState extends State<ReportBugPage> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Report Bug'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'We value your concern!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please share your issues or problem faced, below:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your Concern here...',
              ),
            ),
            const SizedBox(height: 70),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitFeedback();
                },
                child: Text(
                  'Submit Concern',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black
                            .withOpacity(0.5), // Change color based on theme
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    final feedback = _feedbackController.text;
    // Handle feedback submission (e.g., send to server, show a confirmation message, etc.)
    if (feedback.isNotEmpty) {
      // For demonstration, just show a dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Thank You!'),
            content: const Text('Your Concern has been submitted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      _feedbackController.clear(); // Clear the text field
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your Concern.')),
        );
      });
    }
  }
}
