import 'package:flutter/material.dart';

class SesoftElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;

  const SesoftElevatedButton({
    super.key,
    required this.child,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(onPressed: onPressed, icon: icon!, label: child);
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: child,
      );
    }
  }
}
