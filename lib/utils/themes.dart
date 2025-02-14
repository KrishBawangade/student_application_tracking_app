import 'package:flutter/material.dart';
import 'package:student_application_tracking_app/utils/colors.dart';

class AppThemes{
  static ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          contrastLevel: 1,
          seedColor: AppColors.colorPrimary,
          dynamicSchemeVariant: DynamicSchemeVariant.rainbow)); 
}