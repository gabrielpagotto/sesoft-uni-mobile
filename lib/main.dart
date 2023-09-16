import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/app.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.start();
  runApp(const ProviderScope(child: App()));
}
