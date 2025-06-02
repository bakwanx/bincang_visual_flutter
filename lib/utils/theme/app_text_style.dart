import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  /// Dark Blue, 20, w900
  static var headlineLarge = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.darkBlue);

  /// Dark Blue, 18, w900
  static var headlineMedium = TextStyle(
      fontWeight: FontWeight.w900, color: AppColors.darkBlue, fontSize: 18);

  /// Dark Blue, 16, w800
  static var headlineSmall = TextStyle(
      fontWeight: FontWeight.w800, color: AppColors.darkBlue, fontSize: 16);

  /// Dark Blue, 15, w800
  static var titleLarge = TextStyle(
      fontWeight: FontWeight.w800, color: AppColors.darkBlue, fontSize: 15);

  /// B3B3B3, 15, w800
  static var titleDisabledLarge = TextStyle(
      fontWeight: FontWeight.w800, color: Color(0XFFB3B3B3), fontSize: 15);

  /// Dark Blue, 15, Bold (w700)
  static var titleMedium = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.darkBlue, fontSize: 15);

  /// Primary Color, 14, Bold (w700)
  static var actionMedium = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor);

  /// Primary Color, 13, Bold (w700)
  static var actionSmall = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryColor);

  /// Dark Blue, 16, Bold (w700)
  static var labelLarge = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlue);

  /// Dark Blue, 14, Bold (w700)
  static var labelMedium = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkBlue);

  /// Dark Blue, 13, Bold (w700)
  static var labelSmall = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkBlue);

  static var bodyLarge = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87);

  /// Black87, 14, Normal (w400)
  static var bodyNormal = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87);

  /// Black87, 12, Normal (w400)
  static var smallNormal = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87);
}
