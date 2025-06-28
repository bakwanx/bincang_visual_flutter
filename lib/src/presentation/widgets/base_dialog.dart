import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;

  const BaseDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 8,
      backgroundColor: Colors.white,
      content: child,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
    );
  }

  static void show({required BuildContext context, required Widget child}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (BuildContext context) =>
              PopScope(canPop: false, child: BaseDialog(child: child)),
    );
  }
}
