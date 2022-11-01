import 'package:task_manager/core/services/preference_service.dart';

class ThemeServices {
  static const String darkTheme = 'dark';

  static const String lightTheme = 'light';
  static const String themePreferenceKey = 'app_theme';

  static setCurrentTheme(String theme) async {
    await PreferenceService.setPreferenceValue(themePreferenceKey, theme);
  }

  static Future<String> getCurrentTheme() async {
    return await PreferenceService.getPreferenceValue(themePreferenceKey) ??
        darkTheme;
  }
}
