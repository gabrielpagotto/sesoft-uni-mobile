import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/app_settings.dart';
import 'package:sesoft_uni_mobile/src/settings/router.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  List build() => [];

  AppSettings get appSettings => ref.read(appSettingsProvider.notifier);
  AppSettingsState get appSettingsState => ref.read(appSettingsProvider);

  void toggleThemeModeSystem() {
    if (appSettingsState.themeMode == ThemeMode.system) {
      final platformBrightness = MediaQuery.of(navigatorKey.currentContext!).platformBrightness;
      final newThemeMode = platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
      appSettings.changeThemeMode(newThemeMode);
    } else {
      appSettings.changeThemeMode(ThemeMode.system);
    }
  }

  void toggleThemeModeDark() {
    if (appSettingsState.themeMode == ThemeMode.light) {
      appSettings.changeThemeMode(ThemeMode.dark);
    } else {
      appSettings.changeThemeMode(ThemeMode.light);
    }
  }
}
