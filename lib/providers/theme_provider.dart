import 'package:flutter/material.dart';

import '../core/themes/themes.dart';
import '../database/database_services.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  final ThemeService themeService = ThemeService();

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  Future<void> initializeTheme() async {
    bool isDarkTheme = await themeService.getTheme();
    _themeData = isDarkTheme ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    await themeService.toggleTheme();
    bool isDarkTheme = await themeService.getTheme();
    _themeData = isDarkTheme ? darkTheme : lightTheme;
    notifyListeners();
  }
}

