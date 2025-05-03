import 'package:flutter/material.dart';
import 'package:orodomop/themes/custom_theme_data.dart';

ThemeData darkTheme() {
  Color primaryColor = Colors.black; // App background

  // Dialog
  Color dialogTitleTextColor = Colors.white;
  FontWeight dialogTitleWeight = FontWeight.bold;

  Color dialogBackground = Colors.black;
  Color dialogBorderColor = Colors.redAccent;
  Color dialogShadowColor = dialogBorderColor;
  Color dialogInputColor = Colors.white;
  double dialogTitleFontSize = 24;
  double dialogBorderWidth = 2;
  double dialogBorderRadius = 33;
  double dialogElevation = 20;

  // text button color (used by dialog amongst others)
  Color textButtonColor = Colors.white;
  double textButtonFontSize = 18;

  // Buttons
  Color elevatedButtonTextColor = Colors.white;
  Color elevatedButtonColor = dialogBorderColor; // Colors.redAccent;
  Color elevatedButtonShadowColor = elevatedButtonColor;
  double elevatedButtonElevation = 5;
  double elevatedButtonTextSize = 14;
  FontWeight elevatedButtonTextWeight = FontWeight.bold;

  // Toggle theme button color
  Color toggleThemeModeColor = Colors.grey;

  // Timer
  double timerFontSize = 68;
  FontWeight timerFontWeight = FontWeight.bold;
  Color timerTextColor = Colors.white;

  // Not the main use of colorScheme but works for the gradients
  ColorScheme gradientColors = ColorScheme.light(
    primary: Colors.red,
    inversePrimary: Colors.white,
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
