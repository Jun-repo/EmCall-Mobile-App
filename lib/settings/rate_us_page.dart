import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class RateUsPage extends StatefulWidget {
  const RateUsPage({super.key});

  @override
  RateUsPageState createState() => RateUsPageState();
}

class RateUsPageState extends State<RateUsPage> {
  // Index of the last selected star
  int selectedStarIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Rate Us'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How would you rate our app?',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index <= selectedStarIndex
                        ? Icons.star_border_rounded
                        : Icons.star_border_rounded,
                    color: index <= selectedStarIndex ? Colors.redAccent : null,
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      if (index == selectedStarIndex) {
                        // If the star is already selected, deselect it
                        selectedStarIndex = index - 1;
                      } else {
                        // If the star is not selected, select it
                        selectedStarIndex = index;
                      }
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedStarIndex == -1
                  ? null // Disable button if no rating is selected
                  : () {
                      _launchStore(context); // Call to launch the store
                      // _showFeedbackMessage(context); // Show feedback message
                    },
              child: Text(
                'Submit Rating',
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
          ],
        ),
      ),
    );
  }

  Future<void> _launchStore(BuildContext context) async {
    // Define your app's URL in the Play Store and App Store
    const String playStoreUrl =
        'https://play.google.com/store/apps/'; // Replace with your Play Store URL
    const String appStoreUrl =
        'https://apps.apple.com/app/'; // Replace with your App Store URL

    // Check the platform and launch the appropriate URL
    if (kIsWeb) {
      // Handle web version if necessary
      if (kDebugMode) {
        print("Web version is not supported for app rating.");
      }
    } else {
      final Uri url = (Theme.of(context).platform == TargetPlatform.iOS)
          ? Uri.parse(appStoreUrl) // iOS
          : Uri.parse(playStoreUrl); // Android

      // Check if the URL can be launched
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

//   // Function to show feedback message
//   void _showFeedbackMessage(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Thank You!'),
//           content: const Text('Your feedback has been submitted.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
}
