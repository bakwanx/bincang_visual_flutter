import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const CustomTextButton({super.key,
    required this.onPressed,
    required this.child,
    this.minimumSize,
    this.tapTargetSize,
    this.padding,
    this.backgroundColor,});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          tapTargetSize: tapTargetSize,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          minimumSize: minimumSize,
        ),
        child: child);
  }
}
