import 'package:flutter/material.dart';

class ThemeManager {
  static const Color buttonColor = Colors.redAccent; // Custom button color
  static const Color iconColor = Colors.grey; // Icon color
  static const Color onboardiconColor = Colors.white;
  static const Color dotColor = Colors.grey; // Inactive dot color
  static const Color activeDotColor = Colors.redAccent; // Active dot color
  static const Color circleAvatar = Colors.redAccent;
  static const Color text = Color.fromARGB(255, 255, 255, 255);
  static const Color lightbackground = Color.fromARGB(255, 225, 225, 225);
  static const Color darkbackground = Color.fromARGB(255, 15, 15, 15);
  static const Color lightcard = Color.fromARGB(255, 243, 243, 243);
  static const Color darkcard = Color.fromARGB(255, 5, 5, 5);

// LIGHT MODE=======================================================================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: Colors.blue,
    scaffoldBackgroundColor: lightbackground,
    dialogBackgroundColor: Colors.white,

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: lightcard,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Adjusted border radius here
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: lightbackground,
      foregroundColor: Colors.black,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightbackground,
    ),

    snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: TextStyle(color: Colors.black)),

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(Colors.white), // Background color
        surfaceTintColor: WidgetStateProperty.all<Color>(
            Colors.grey[200]!), // Optional tint color
      ),
      textStyle: const TextStyle(color: Colors.black), // Text color
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Set border radius
        side: const BorderSide(color: Colors.black), // Border color and width
      ),
      checkColor: WidgetStateProperty.all(
          Colors.redAccent), // Color of the check icon inside the checkbox
      fillColor: WidgetStateProperty.all(
          Colors.white), // Background color of the checkbox
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.normal), // Large body text
      headlineMedium: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Colors.black, fontSize: 10, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: Colors.black87), // Medium body text
      bodySmall: TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w300), // Small body text
      titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold), // Headlines
      titleMedium: TextStyle(
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.w300), // Medium headlines or subtitles

      titleSmall: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.bold), // Small headlines or subtitles
    ),

    // Define button and other color styles here
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black, // Set text button color
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        color: Colors.black87, // Label text color
        fontSize: 16, // Set the label text size
        fontWeight: FontWeight.w300,
      ),
      hintStyle: const TextStyle(color: Colors.black54), // Hint text color
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.black54), // Default border color
        borderRadius: BorderRadius.circular(8), // Border radius
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.black), // Enabled border color
        borderRadius: BorderRadius.circular(8), // Border radius
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.redAccent), // Focused border color
        borderRadius: BorderRadius.circular(8), // Border radius
      ),
    ),
  );

//DARK MODE======================================================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.blue,
    scaffoldBackgroundColor: darkbackground,
    dialogBackgroundColor: const Color.fromARGB(255, 26, 26, 26),

    cardTheme: CardTheme(
      color: darkcard,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Adjusted border radius here
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkbackground,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkbackground,
    ),

    snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color.fromARGB(255, 26, 26, 26),
        contentTextStyle: TextStyle(color: Colors.white)),

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(Colors.black), // Background color
        surfaceTintColor: WidgetStateProperty.all<Color>(
            Colors.grey[200]!), // Optional tint color
      ),
      textStyle: const TextStyle(color: Colors.white), // Text color
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Set border radius
        side: const BorderSide(color: Colors.black), // Border color and width
      ),
      checkColor: WidgetStateProperty.all(
          Colors.redAccent), // Color of the check icon inside the checkbox
      fillColor: WidgetStateProperty.all(
          Colors.black), // Background color of the checkbox
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 26, 26, 26),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.normal), // Large body text
      headlineMedium: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),

      bodyMedium: TextStyle(color: Colors.white), // Medium body text
      bodySmall: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w300), // Small body text
      titleLarge: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: Colors.white54,
          fontSize: 16,
          fontWeight: FontWeight.w300), // subtitles

      titleSmall: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold), // Small headlines or subtitles
    ),

    // Define button and other color styles here
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Set text button color
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        color: Colors.white70, // Label text color
        fontSize: 16, // Set the label text size
        fontWeight: FontWeight.w300,
      ),
      hintStyle: const TextStyle(color: Colors.white54), // Hint text color
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.white60), // Default border color
        borderRadius: BorderRadius.circular(8), // Border radius
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.white), // Enabled border color
        borderRadius: BorderRadius.circular(8), // Border radius
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.redAccent), // Focused border color
        borderRadius: BorderRadius.circular(8), // Border radius
      ),
    ),
  );
}
