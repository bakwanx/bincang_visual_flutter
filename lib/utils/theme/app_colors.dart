import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AppColors {
  AppColors._();
  static const primaryColor = Color(0XFF015186);
  static const green = Color(0XFF7ABC51);
  static const secondaryLightColor = Color(0XFF75D0C6);
  static const secondaryColor = Color(0XFF00B29D);
  static const secondaryTrans = Color(0X1A00B29D);

  static const primaryButtonBackground = primaryColor;
  static const disabledPrimaryButtonBackground = Color(0XFFE6E6E6);
  static const disabledPrimaryButtonForeground = Color(0XFFB3B3B3);

  static const outlinedButtonBorder = primaryColor;
  static const outlinedButtonForeground = primaryColor;
  static const disabledOutlinedButtonBackground = Color(0XFFE6E6E6);
  static const disabledOutlinedButtonForeground = Color(0XFFB3B3B3);

  static const darkBlue = Color(0XFF34495E);
  static const lightestBlue = Color(0XFFF3F9FF);
  static const lightGrey = Color(0XFFB3B3B3);
  static const lighterGrey = Color(0XFFD9D9D9);
  static const lightestGrey = Color(0XFFF0F2F3);
  static const white = Colors.white;
  static const grey = Colors.grey;
  static const greyNeutral200 = Color(0xffF2F2F2);
  static const greyNeutral600 = Color(0xff8F8F8F);
  static const areaDisabled = Color(0xFFF3F9FF);

  static const divider = lightGrey;

  // TextFormField
  static const enabledTextFormFieldOutlinedBorder = lighterGrey;
  static const focusedTextFormFieldOutlinedBorder = primaryColor;
  static const hintTextFormField = lightGrey;
  static const labelTextFormField = lightGrey;
  static const floatingLabelTextFormField = primaryColor;
}
