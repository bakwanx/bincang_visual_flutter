import 'package:flutter/material.dart';

import '../../../../utils/theme/app_colors.dart';



class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;
  final EdgeInsetsGeometry? padding;
  const CustomOutlinedButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.minimumSize,
      this.tapTargetSize,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          tapTargetSize: tapTargetSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: BorderSide(
              color: onPressed == null
                  ? Colors.transparent
                  : AppColors.outlinedButtonBorder),
          foregroundColor: AppColors.outlinedButtonForeground,
          disabledBackgroundColor: AppColors.disabledOutlinedButtonBackground,
          disabledForegroundColor: AppColors.disabledOutlinedButtonForeground,
          minimumSize: minimumSize,
        ),
        child: child);
  }
}
