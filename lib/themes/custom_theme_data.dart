import 'package:flutter/material.dart';

ThemeData customThemeData(
  Color primaryColor,
  double timerFontSize,
  FontWeight timerFontWeight,
  Color timerTextColor,
  Color dialogInputColor,
  ColorScheme gradientColors,
  Color dialogShadowColor,
  double dialogElevation,
  Color dialogBorderColor,
  double dialogBorderWidth,
  double dialogBorderRadius,
  Color dialogTitleTextColor,
  FontWeight dialogTitleWeight,
  double dialogTitleFontSize,
  Color dialogBackground,
  Color textButtonColor,
  double textButtonFontSize,
  double elevatedButtonElevation,
  Color elevatedButtonShadowColor,
  Color elevatedButtonTextColor,
  Color elevatedButtonColor,
  double elevatedButtonTextSize,
  FontWeight elevatedButtonTextWeight,
  Color toggleThemeModeColor,
) {
  return ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey, // Change this to your desired hint text color
      ),
    ),
    // For the time counters.
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: timerFontSize,
        fontWeight: timerFontWeight,
        color: timerTextColor,
      ),
      bodyMedium: TextStyle(fontSize: 18, color: dialogInputColor),
      bodySmall: TextStyle(fontSize: 15, color: toggleThemeModeColor),
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
