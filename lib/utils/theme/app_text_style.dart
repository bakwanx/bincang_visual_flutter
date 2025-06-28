import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static var headlineLarge = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.darkBlue);

  static var headlineMedium = TextStyle(
      fontWeight: FontWeight.w900, color: AppColors.darkBlue, fontSize: 18);

  static var headlineSmall = TextStyle(
      fontWeight: FontWeight.w800, color: AppColors.darkBlue, fontSize: 16);

  static var titleLarge = TextStyle(
      fontWeight: FontWeight.w800, color: AppColors.darkBlue, fontSize: 15);

  static var titleDisabledLarge = TextStyle(
      fontWeight: FontWeight.w800, color: Color(0XFFB3B3B3), fontSize: 15);

  static var titleMedium = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.darkBlue, fontSize: 15);

  static var labelLarge = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlue);

  static var labelMedium = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkBlue);

  static var labelSmall = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkBlue);

  static var bodyLarge = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black);

  static var bodyMedium = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black);

  static var smallNormal = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black);
}
