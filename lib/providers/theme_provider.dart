import 'package:flutter/material.dart';

import '../core/themes/themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.light ? darkTheme : lightTheme;
    notifyListeners();
  }
}