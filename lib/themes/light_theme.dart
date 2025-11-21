import 'package:flutter/material.dart';
import 'package:orodomop/themes/custom_theme_data.dart';

ThemeData lightTheme() {
  Color primaryColor = Colors.white; // App background

  // Dialog
  Color dialogTitleTextColor = Colors.black;
  FontWeight dialogTitleWeight = FontWeight.bold;
  Color dialogInputColor = Colors.black;

  Color dialogBackground = Colors.white;
  Color dialogBorderColor = Colors.redAccent;
  Color dialogShadowColor = dialogBorderColor;
  double dialogTitleFontSize = 19;
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

  // Toggle theme button color
  Color toggleThemeModeColor = Colors.redAccent;

  // Timer
  double timerFontSize = 68;
  FontWeight timerFontWeight = FontWeight.bold;
  Color timerTextColor = Colors.black;
  // Not the main use of colorScheme but works for the gradients
  ColorScheme gradientColors = ColorScheme.light(
    primary: Colors.black,
    inversePrimary: Colors.red,
  );
  return customThemeData(
    primaryColor,
    timerFontSize,
    timerFontWeight,
    timerTextColor,
    dialogInputColor,
    gradientColors,
    dialogShadowColor,
    dialogElevation,
    dialogBorderColor,
    dialogBorderWidth,
    dialogBorderRadius,
    dialogTitleTextColor,
    dialogTitleWeight,
    dialogTitleFontSize,
    dialogBackground,
    textButtonColor,
    textButtonFontSize,
    elevatedButtonElevation,
    elevatedButtonShadowColor,
    elevatedButtonTextColor,
    elevatedButtonColor,
    elevatedButtonTextSize,
    elevatedButtonTextWeight,
    toggleThemeModeColor,
  );
}
