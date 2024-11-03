import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:emcall/auth/sign_in_screen_sugesstion.dart';
// import 'package:emcall/l10n/l10n.dart';
import 'package:emcall/onboarding_screen.dart';
import 'package:emcall/services/notification.dart';
import 'package:emcall/theme/theme_manager.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Retrieve the saved theme mode
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // Check if the user is new
  final bool isNewUser = await checkIfNewUser();

  runApp(
    OnboardingApp(
      savedThemeMode: savedThemeMode,
      isNewUser: isNewUser,
    ),
  );
}

// Function to check if the user is new
Future<bool> checkIfNewUser() async {
  final prefs = await SharedPreferences.getInstance();
  final isNewUser =
      prefs.getBool('isNewUser') ?? true; // Default to true if not set
  return isNewUser;
}

class OnboardingApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final bool isNewUser;

  const OnboardingApp({
    super.key,
    this.savedThemeMode,
    required this.isNewUser,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeManager.lightTheme,
      dark: ThemeManager.darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // supportedLocales: L10n.all,
        // locale: const Locale('en'),
        // localizationsDelegates: const [
        //   AppLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        title: 'EmCall™',
        theme: theme,
        darkTheme: darkTheme,
        home: isNewUser ? const OnboardingScreen() : const SignInScreen(),
      ),
      debugShowFloatingThemeButton: true,
    );
  }
}
