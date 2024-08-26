import 'package:asignment_9_google_map/Presentation/ui/screens/google_map_screen.dart';
import 'package:asignment_9_google_map/Presentation/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class GoogleMapApp extends StatelessWidget {
  const GoogleMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GoogleMapScreen(),
      theme: AppTheme.lightThemeData(),
      darkTheme: AppTheme.darkThemeData(),
      themeMode: ThemeMode.system,
    );
  }
}
