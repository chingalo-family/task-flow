import 'package:flutter/foundation.dart';
import 'package:task_manager/core/services/theme_service.dart';

class AppThemeState with ChangeNotifier {
  String? _currentTheme;

  String get currentTheme => _currentTheme ?? ThemeServices.darkTheme;

  void setCurrentTheme(String theme) async {
    _currentTheme = theme;
    await ThemeServices.setCurrentTheme(theme);
    notifyListeners();
  }
}
