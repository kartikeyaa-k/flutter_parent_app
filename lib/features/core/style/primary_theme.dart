import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class PrimaryTheme {
  // Define your primary, secondary, and alternative colors here
  static const Color primaryColor = Color(0xFF66CCCC);
  static const Color secondaryColor = Color(0xFFFFFFFF);
  static const Color alternativeColor = Color.fromARGB(255, 76, 0, 158);

  // Define your text styles here
  static const TextStyle headingTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  static const TextStyle subheadingTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );
  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
  static const TextStyle categoriesTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.black87,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: alternativeColor,
  );
  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
    fontFamily: 'DM Sans',
  );

  /// APP BAR
  // Driver Home and Customer Home screen App Bar
  static TextStyle appBarStyle = const TextStyle(
    fontFamily: 'Hannari',
    color: Color(0xFF000000),
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 0.4,
  );
  static TextStyle dropdownStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontFamily: 'DM Sans',
  );

  // All other app bars inside the app post login

  // Define your theme data here
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      textTheme: const TextTheme(
        displayLarge: headingTextStyle,
        displayMedium: subheadingTextStyle,
        bodyLarge: bodyTextStyle,
        bodyMedium: labelTextStyle,
        titleMedium: hintTextStyle,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
    );
  }
}
