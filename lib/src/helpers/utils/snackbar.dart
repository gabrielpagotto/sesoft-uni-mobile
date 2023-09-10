import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/settings/router.dart';

class SesoftSnackbar {
  static BuildContext _getContext() {
    return navigatorKey.currentState!.context;
  }

  static success(String message) {
    _getContext().snackBar(message);
  }

  static error(String message) {
    _getContext().snackBar(message, isError: true);
  }
}
