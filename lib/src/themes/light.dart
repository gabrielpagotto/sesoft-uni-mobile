import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/themes/base.dart';

ThemeData lightTheme() => ThemeData(
      useMaterial3: false,
      colorScheme: const ColorScheme.light(),
      elevatedButtonTheme: baseElevatedButtonTheme(),
      inputDecorationTheme: baseInputDecorationTheme(),
    );
