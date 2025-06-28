import 'package:flutter/material.dart';

import '../../../utils/theme/app_text_style.dart';

class CustomSnackBar{


  CustomSnackBar({required BuildContext context, required String message}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyle.bodyMedium.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}