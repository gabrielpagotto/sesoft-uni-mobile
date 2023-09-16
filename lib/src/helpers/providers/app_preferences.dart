import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences.g.dart';

late SharedPreferences _sharedPreferences;

class AppPreferencesState {
  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }
}

@riverpod
class AppPreferences extends _$AppPreferences {
  @override
  AppPreferencesState build() => AppPreferencesState();

  static Future<void> start() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return _sharedPreferences.setString(key, value);
  }
}
