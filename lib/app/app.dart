import 'package:asignment_9_google_map/Presentation/ui/controllers/map_controller.dart';
import 'package:asignment_9_google_map/Presentation/ui/screens/google_map_screen.dart';
import 'package:asignment_9_google_map/Presentation/ui/themes/app_theme.dart';
import 'package:asignment_9_google_map/bindings/controller_bindings.dart';
import 'package:asignment_9_google_map/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleMapApp extends StatelessWidget {
  const GoogleMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBindings(),
      getPages: AppRoutes.appRoutes(),
      theme: AppTheme.lightThemeData(),
      darkTheme: AppTheme.darkThemeData(),
      themeMode: ThemeMode.system,
    );
  }
}
