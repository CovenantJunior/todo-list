
import 'package:flutter/material.dart';
import 'package:note_app/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  // Initial Theme
  ThemeData _themeData = darkMode;

  // Access theme from other parts of the code
  ThemeData get themeData => _themeData;

  // Check if theme is dark
  bool get isDarkMode => themeData == darkMode;

  // Set new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}