import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  BuildContext get _context => this;

  ThemeData get theme => Theme.of(_context);

  TextTheme get textTheme => theme.textTheme;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(String message, {bool isError = false}) {
    final icon = isError ? Icons.info_outline : Icons.check_circle_outline;
    final backgroundColor = isError ? theme.colorScheme.errorContainer : theme.colorScheme.tertiaryContainer;
    final foregroundColor = isError ? theme.colorScheme.error : theme.colorScheme.tertiary;
    final snackBar = SnackBar(
      showCloseIcon: true,
      backgroundColor: backgroundColor,
      closeIconColor: foregroundColor,
      content: Row(
        children: [
          Icon(icon, color: foregroundColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: foregroundColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    return ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }
}
