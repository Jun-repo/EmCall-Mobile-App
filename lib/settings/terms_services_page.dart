import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight, // Ensures it fills the screen height
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Service',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'By accessing or using EmCall, you agree to comply with and be bound by the following terms and conditions:',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    const _SectionHeader(title: '1. Acceptance of Terms:'),
                    Text(
                      'By accessing or using EmCall, you agree to these Terms of Service. If you do not agree, please do not use the application.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const _SectionHeader(title: '2. User Responsibilities:'),
                    Text(
                      'You must provide accurate and complete information during registration. You are responsible for maintaining the confidentiality of your account.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const _SectionHeader(title: '3. Content Ownership:'),
                    Text(
                      'All content created within EmCall is owned by you. However, by using our application, you grant us a non-exclusive, worldwide, royalty-free license to use, reproduce, and display your content.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const _SectionHeader(title: '4. Termination:'),
                    Text(
                      'We reserve the right to suspend or terminate your access to EmCall if you violate these terms.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const _SectionHeader(title: '5. Limitation of Liability:'),
                    Text(
                      'EmCall is not liable for any indirect, incidental, or consequential damages arising from your use of the application.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const _SectionHeader(title: '6. Changes to Terms:'),
                    Text(
                      'We may update these terms from time to time. We will notify you of any significant changes.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Contact Us',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'If you have any questions or concerns regarding these terms, please contact us at:',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '[Globe 63+ 9567211558]',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(), // Pushes the content upwards if there is extra space
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
