import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('About App'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // Ensure minimum height
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EmCall - Emergency Response App',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Version: 1.0.0',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Purpose',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'EmCall is designed to help individuals quickly connect with emergency responders and services in times of need. The app provides an easy-to-use interface for users to send alerts, share real-time locations, and contact relevant services.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Features',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• Quick access to emergency contacts\n'
                      '• Real-time location sharing with responders\n'
                      '• Integrated map view for tracking\n'
                      '• Support for both Android and iOS',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Developer Information',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Developed by: EmCall Team\n'
                      'Contact: emcallcompany@gmail.com\n'
                      'Phone: Globe 63+ 9567211558',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const Spacer(), // Pushes copyright text to the bottom
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          '© 2024 EmCall. All rights reserved.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
