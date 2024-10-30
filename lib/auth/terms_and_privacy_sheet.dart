import 'package:flutter/material.dart';

class TermsAndPrivacySheet extends StatelessWidget {
  const TermsAndPrivacySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'By accessing or using EmCall, you agree to comply with and be bound by the following terms and conditions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Acceptance of Terms: By accessing or using EmCall, you agree to these Terms of Service. If you do not agree, please do not use the application.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '2. User Responsibilities: You must provide accurate and complete information during registration. You are responsible for maintaining the confidentiality of your account.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '3. Content Ownership: All content created within EmCall is owned by you. However, by using our application, you grant us a non-exclusive, worldwide, royalty-free license to use, reproduce, and display your content.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '4. Termination: We reserve the right to suspend or terminate your access to EmCall if you violate these terms.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '5. Limitation of Liability: EmCall is not liable for any indirect, incidental, or consequential damages arising from your use of the application.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '6. Changes to Terms: We may update these terms from time to time. We will notify you of any significant changes.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const SizedBox(height: 20),
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Effective Date: [2024 until 2030]',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            const Text(
              'At EmCall, we are committed to protecting your privacy. This Privacy Policy outlines how we collect, use, and protect your information.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '1. Information We Collect: Personal Information: We collect your full name, phone number, birthday, and profile image during registration.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '2. How We Use Your Information: To provide and maintain the application; to notify you about changes to our services; to provide customer support.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '3. Data Sharing: We do not sell or share your personal information with third parties without your consent, except as required by law.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '4. Data Security: We implement appropriate security measures to protect your information from unauthorized access.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '5. Your Rights: You have the right to access, correct, or delete your personal information. You can contact us to exercise these rights.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '6. Changes to This Privacy Policy: We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Text(
              '7. Contact Us: If you have any questions about these terms or our privacy practices, please contact us at [Globe 63+ 9567211558].',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54, // Set button color to black
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(26), // Optional: Rounded corners
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Colors
                        .white60, // Set text color to white with 60% opacity
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
