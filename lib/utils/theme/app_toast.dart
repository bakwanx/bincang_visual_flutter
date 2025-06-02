import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void showToast({
    required String message,
    Toast toastLength = Toast.LENGTH_LONG,
    Color bgColor = Colors.grey,
    Color textColor = Colors.white,
    double fontSize = 16,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}