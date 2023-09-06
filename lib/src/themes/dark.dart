import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/themes/base.dart';

ThemeData darkTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        brightness: Brightness.dark,
      ),
      elevatedButtonTheme: baseElevatedButtonTheme(),
      inputDecorationTheme: baseInputDecorationTheme(),
    );
