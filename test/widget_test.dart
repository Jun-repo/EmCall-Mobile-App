import 'package:emcall/onboarding_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emcall/main.dart'; // Ensure this imports your main.dart file

void main() {
  testWidgets('Onboarding or Sign-in screen is displayed',
      (WidgetTester tester) async {
    // Create a test widget with the same parameters used in your main.dart
    await tester.pumpWidget(
      const OnboardingApp(
        savedThemeMode: null, // Mock the theme mode (optional)
        isNewUser: true, // Test with isNewUser set to true for onboarding
      ),
    );

    // Verify that the OnboardingScreen is displayed initially for new users
    expect(find.byType(OnboardingScreen), findsOneWidget);

    // Optional: Trigger a frame to see if the widget builds correctly.
    await tester.pump();

    // Example interaction or further checks could go here...
  });
}
