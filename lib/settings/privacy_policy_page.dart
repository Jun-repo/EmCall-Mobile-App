import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints
                    .maxHeight, // Ensures content takes at least the screen height
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Effective Date: [2024 until 2030]',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'At EmCall, we are committed to protecting your privacy. This Privacy Policy outlines how we collect, use, and protect your information.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '1. Information We Collect:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Personal Information: We collect your full name, phone number, birthday, and profile image during registration.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '2. How We Use Your Information:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'To provide and maintain the application; to notify you about changes to our services; to provide customer support.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '3. Data Sharing:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'We do not sell or share your personal information with third parties without your consent, except as required by law.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '4. Data Security:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'We implement appropriate security measures to protect your information from unauthorized access.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '5. Your Rights:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'You have the right to access, correct, or delete your personal information. You can contact us to exercise these rights.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '6. Changes to This Privacy Policy:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '7. Contact Us:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'If you have any questions about these terms or our privacy practices, please contact us at [Globe 63+ 9567211558].',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const Spacer(), // Pushes the content upward
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
