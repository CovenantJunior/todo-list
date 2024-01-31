import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/models/todo_preferences.dart';

class  TodoPreferencesDatabase extends ChangeNotifier {
  static late Isar isar;
  
  // Initialize Preference DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoPreferencesSchema],
      directory: dir.path
    );
  }

  List preferences = [];

  void createPreference () async {
    final newPreference = TodoPreferences()..darkMode = true..notification = true..backup = true..autoSync = true..autoDelete = true;
    await isar.writeTxn(() => isar.todoPreferences.put(newPreference));

    fetchPreferences();
  }

  void fetchPreferences () async {
    List currentPreferences = isar.todoPreferences.where().findAllSync();
    if (currentPreferences.isEmpty) {
      // Create user preference is none exists
      createPreference();
    } else {
      preferences.clear();
      preferences.addAll(currentPreferences);
      notifyListeners();
    }
  }
}