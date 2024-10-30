import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'If you have any questions or feedback, feel free to reach out to us!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Developer Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Company: EmCall Company',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Email: emcallcompany@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Phone: +1 (123) 456-7890',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Follow Us:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'emcallcompany@gmail.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Hi! What can we do for you maam/sir?',
                      }),
                    );
                    launchUrl(emailLaunchUri);

                    // Using try-catch for better error handling
                    try {
                      // Check if the email can be launched
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        throw 'Could not launch $emailLaunchUri';
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print('Error: $e');
                      } // Log the error for debugging
                      // Optionally show a dialog or a snackbar to inform the user
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.web),
                  onPressed: () async {
                    const url =
                        'https://www.example.com'; // Replace with your website URL
                    final Uri webUri = Uri.parse(url);
                    if (await canLaunchUrl(webUri)) {
                      await launchUrl(webUri);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.link_rounded),
                  onPressed: () async {
                    const url =
                        'https://www.linkedin.com/in/johndoe'; // Replace with your LinkedIn URL
                    final Uri linkedInUri = Uri.parse(url);
                    if (await canLaunchUrl(linkedInUri)) {
                      await launchUrl(linkedInUri);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
