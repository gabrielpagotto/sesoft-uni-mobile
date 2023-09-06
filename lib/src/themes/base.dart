import 'package:flutter/material.dart';

baseElevatedButtonTheme() => ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.all(14)),
      ),
    );

baseInputDecorationTheme() => const InputDecorationTheme(
      contentPadding: EdgeInsets.all(10),
      border: UnderlineInputBorder(),
      filled: false,
    );
