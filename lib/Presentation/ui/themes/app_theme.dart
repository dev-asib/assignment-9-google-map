import 'package:asignment_9_google_map/Presentation/ui/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightThemeData() {
    return ThemeData(
      appBarTheme: appBarTheme(),
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
      appBarTheme: appBarTheme(),
    );
  }

  static AppBarTheme appBarTheme() {
    return const AppBarTheme(
      backgroundColor: AppColors.deepPurpleColor,
      foregroundColor: AppColors.whiteColor,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 24,
      ),
      centerTitle: true,
    );
  }

}
