import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/themes/base.dart';

ThemeData darkTheme() => FlexThemeData.dark(
      useMaterial3: true,
      scheme: FlexScheme.orangeM3,
      darkIsTrueBlack: true,
      swapLegacyOnMaterial3: true,
    ).copyWith(
      elevatedButtonTheme: baseElevatedButtonTheme(),
      inputDecorationTheme: baseInputDecorationTheme(),
    );
