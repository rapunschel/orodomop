import 'package:flutter/material.dart';

ThemeData lightTheme() {
  Color primaryColor = Colors.white; // App background

  // Dialog
  Color dialogTitleTextColor = Colors.black;
  FontWeight dialogTitleWeight = FontWeight.bold;

  Color dialogBackground = Colors.white;
  Color dialogBorderColor = Colors.redAccent;
  Color dialogShadowColor = dialogBorderColor;
  double dialogTitleFontSize = 24;
  double dialogBorderWidth = 2;
  double dialogBorderRadius = 33;
  double dialogElevation = 20;

  // text button color (used by dialog amongst others)
  Color textButtonColor = dialogBorderColor;
  double textButtonFontSize = 18;

  // Buttons
  Color elevatedButtonTextColor = Colors.black;
  Color elevatedButtonColor = dialogBorderColor; // Colors.redAccent;
  Color elevatedButtonShadowColor = elevatedButtonColor;
  double elevatedButtonElevation = 5;
  double elevatedButtonTextSize = 14;
  FontWeight elevatedButtonTextWeight = FontWeight.bold;

  // Timer
  double timerFontSize = 68;
  FontWeight timerFontWeight = FontWeight.bold;

  // Not the main use of colorScheme but works for the gradients
  ColorScheme gradientColors = ColorScheme.light(
    primary: Colors.black,
    inversePrimary: Colors.red,
  );
  return ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,

    // For the time counters.
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: timerFontSize,
        fontWeight: timerFontWeight,
      ),
    ),
    // Gradient border colors
    colorScheme: gradientColors,
    // Dialog
    dialogTheme: DialogTheme(
      shadowColor: dialogShadowColor,
      elevation: dialogElevation,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: dialogBorderColor, width: dialogBorderWidth),

        borderRadius: BorderRadius.circular(dialogBorderRadius),
      ),
      titleTextStyle: TextStyle(
        color: dialogTitleTextColor,
        fontWeight: dialogTitleWeight,
        fontSize: dialogTitleFontSize,
      ),
      contentTextStyle: TextStyle(
        color: dialogTitleTextColor,
        fontSize: dialogTitleFontSize,
      ),
      backgroundColor: dialogBackground,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textButtonColor,
        textStyle: TextStyle(
          fontSize: textButtonFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.resolveWith<double>((states) {
          return elevatedButtonElevation;
        }),

        shadowColor: WidgetStateProperty.resolveWith<Color>((states) {
          return elevatedButtonShadowColor;
        }),
        // Color for the text
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          return elevatedButtonTextColor;
        }),

        // Button color
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          return elevatedButtonColor;
        }),

        // Text style
        textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          return TextStyle(
            fontSize: elevatedButtonTextSize,
            fontWeight: elevatedButtonTextWeight,
          );
        }),
      ),
    ),
  );
}
