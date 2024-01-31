
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:todo_list/models/todo_preferences.dart';
import 'package:todo_list/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  static late Isar isar;

  

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
    List currentPreferences = isar.todoPreferences.where().findAllSync();
    List preferences = [];
    preferences.clear();
    preferences.addAll(currentPreferences);
    for (var preference in preferences) {
      if (preference.darkMode == false) {
        themeData = darkMode;
      } else {
        themeData = lightMode;
      }
    }
  }
}