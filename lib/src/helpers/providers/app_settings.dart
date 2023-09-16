import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/app_preferences.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettingsState with _$AppSettingsState {
  factory AppSettingsState({
    required ThemeMode themeMode,
  }) = _AppSettingsState;
}

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  @override
  AppSettingsState build() {
    final appPreferencesState = ref.read(appPreferencesProvider);
    final themeModeName = appPreferencesState.getString(_themeModeKey);
    late ThemeMode themeMode;
    if (themeModeName == null) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.values.firstWhere((element) => element.name == themeModeName);
    }
    return AppSettingsState(themeMode: themeMode);
  }

  AppPreferences get appPreferences => ref.read(appPreferencesProvider.notifier);

  static final _themeModeKey = '$AppSettings.ThemeMode';

  void changeThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await appPreferences.setString(_themeModeKey, themeMode.name);
  }
}
