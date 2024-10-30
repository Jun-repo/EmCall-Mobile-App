import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:emcall/auth/sign_in_screen_sugesstion.dart';
import 'package:emcall/theme/theme_manager.dart'; // Adjust the import according to your project structure
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNewUser', false); // Mark user as returning

    if (mounted) {
      // Navigate to SignInScreen after saving preferences
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // PageView for the onboarding slides
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = (index == 2);
              });
            },
            children: [
              buildPageContent(
                context,
                "assets/onboarding1.png",
                "Welcome to EmCall!",
                "Stay connected with Responders in your town.",
                theme,
              ),
              buildPageContent(
                context,
                "assets/onboarding1.png",
                "Easy Report!",
                "Send Alert effortlessly.",
                theme,
              ),
              buildPageContent(
                context,
                "assets/onboarding1.png",
                "Real-time Location!",
                "Share your location with Agencies.",
                theme,
              ),
            ],
          ),
          // Skip button positioned at the top-right
          Positioned(
            top: 50.0,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color ??
                      Colors.grey, // Use theme color
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Page indicator and Next/Start button at the bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Dot Indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const WormEffect(
                    dotColor: ThemeManager.dotColor, // Use custom dot color
                    activeDotColor: ThemeManager
                        .activeDotColor, // Use custom active dot color
                  ),
                ),
                const SizedBox(height: 20),
                // Circular Next/Start button
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      ThemeManager.buttonColor, // Use custom button color
                  child: IconButton(
                    icon: Icon(
                      size: 40,
                      _isLastPage ? Icons.check : Icons.arrow_forward,
                      color: ThemeManager
                          .onboardiconColor, // Use custom icon color
                    ),
                    onPressed: () {
                      if (_isLastPage) {
                        // Navigate to Sign In Screen on last page
                        completeOnboarding();
                      } else {
                        // Go to next page
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageContent(BuildContext context, String image, String title,
      String subtitle, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(image, height: 300),
        const SizedBox(height: 20.0),
        Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8.0),
        Text(
          subtitle,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        const SizedBox(height: 90.0),
      ],
    );
  }
}
