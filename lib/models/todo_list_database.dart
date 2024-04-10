import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/models/todo_preferences.dart';

class TodoListDatabase extends ChangeNotifier{
  static late Isar isar;

  // Initialize DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoListSchema, TodoPreferencesSchema],
      directory: dir.path
    );
  }

  // List of all TodoLists
  List<TodoList> todolists = [];

  List<TodoList> nonTrashedTodolists = [];

  List<TodoList> nonStarredTodolists = [];

  List<TodoList> trashedTodoLists = [];

  List<TodoList> starredTodoLists = [];

  List preferences = [];

  bool? isDark;


  /* PREFERENCES METHODS */

  void initPreference () async {
    List currentPreferences = isar.todoPreferences.where().findAllSync();
    if (currentPreferences.isEmpty) {
      final newPreference = TodoPreferences()
        ..darkMode = false
        ..notification = true
        ..vibration = true
        ..stt = false
        ..backup = false
        ..autoSync = false
        ..accessClipboard = false
        ..autoDelete = false
        ..autoDeleteOnDismiss = true
        ..bulkTrash = false;
      await isar.writeTxn(() => isar.todoPreferences.put(newPreference));
      preferences = isar.todoPreferences.where().findAllSync();
      notifyListeners();
    } else if (currentPreferences.length > 1) {
      await isar.writeTxn(() => isar.todoPreferences.clear());
      initPreference();
    }
  }

  void themePreference () async {
    final currentPreference = isar.todoPreferences.where().findAllSync();
    if (currentPreference.isEmpty) {
      initPreference();
      isDark = currentPreference.first.darkMode!;
    } else if (currentPreference.length > 1) {
      await isar.writeTxn(() => isar.todoPreferences.clear());
      initPreference();
    } else {
      // print("Preference length is ${currentPreference.length}");
      isDark = currentPreference.first.darkMode!;
    }
  }

  void fetchPreferences () async {
    List currentPreferences = isar.todoPreferences.where().findAllSync();
    if (currentPreferences.isEmpty) {
      initPreference();
    } else {
      preferences.clear();
      preferences.addAll(currentPreferences);
      isDark = preferences.first.darkMode;
      // print(currentPreferences.length);
      notifyListeners();
    }
  }

  void reserPreferences() async {
    await isar.writeTxn(() => isar.todoPreferences.clear());
  }

  void setDarkMode (id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    // print(existingPreference?.darkMode);
    if (existingPreference != null) {
      existingPreference.darkMode == false ?  existingPreference.darkMode = true : existingPreference.darkMode = false;

      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.darkMode = existingPreference.darkMode;
      isDark = existingPreference.darkMode;

      // print("$isDark + ${preferences.first.darkMode}");
      fetchPreferences();
    }
  }

  void setNotification (id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.notification == false ?  existingPreference.notification = true : existingPreference.notification = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.notification = existingPreference.notification;
    }
    
    fetchPreferences();
  }

  void setVibration (id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.vibration == false ?  existingPreference.vibration = true : existingPreference.vibration = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.vibration = existingPreference.vibration;
    }
    
    fetchPreferences();
  }

  void setSTT (id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.stt == false ?  existingPreference.stt = true : existingPreference.stt = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.stt = existingPreference.stt;
    }
    
    fetchPreferences();
  }

  void setBackup (id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.backup == false ?  existingPreference.backup = true : existingPreference.backup = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.backup = existingPreference.backup;
    }
    
    fetchPreferences();
  }
  
  void setAutoSync (id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.autoSync == false ?  existingPreference.autoSync = true : existingPreference.autoSync = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.autoSync = existingPreference.autoSync;
    }
    
    fetchPreferences();
  }
  
  void setAccessClipboard(id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.accessClipboard == false ?  existingPreference.accessClipboard = true : existingPreference.accessClipboard = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.accessClipboard = existingPreference.accessClipboard;
    }
    
    fetchPreferences();
  }
  
  void setAutoDelete (id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.autoDelete == false ?  existingPreference.autoDelete = true : existingPreference.autoDelete = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.autoDelete = existingPreference.autoDelete;
    }
    
    fetchPreferences();
  }

  void setAutoDeleteonDismiss(id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.autoDeleteOnDismiss == false
          ? existingPreference.autoDeleteOnDismiss = true
          : existingPreference.autoDeleteOnDismiss = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.autoDeleteOnDismiss = existingPreference.autoDeleteOnDismiss;
    }

    fetchPreferences();
  }

  void setBulkTrash(id) async {
    var existingPreference = await isar.todoPreferences.get(id);
    if (existingPreference != null) {
      existingPreference.bulkTrash == false
          ? existingPreference.bulkTrash = true
          : existingPreference.bulkTrash = false;
      await isar.writeTxn(() => isar.todoPreferences.put(existingPreference));
      preferences.first.bulkTrash = existingPreference.bulkTrash;
    }

    fetchPreferences();
  }
  
  
  
  
  /* TODOLIST METHODS */

  // CREATE
  void addTodoList(plan, category, due, intvl) async {
    final newTodoList = TodoList()..plan = plan..category = category..completed = false..created = DateTime.now()..due = DateTime.parse(due)..starred = false..trashed = false..interval = intvl;

    // Save to DB
    await isar.writeTxn(() => isar.todoLists.put(newTodoList));
    
    // Update TodoList List
    fetchTodoList();
  }


  // READ
  void fetchTodoList() async {
    fetchAllTodoList();
    fetchUntrashedTodoList();
    fetchTrashedTodoList();
    fetchStarredTodoList();
    fetchPreferences();
  }

  void fetchAllTodoList() async {
 
    // READ LIST NOT TRASHED
    final currentTodoLists = isar.todoLists.where().findAllSync();
    todolists.clear();
    todolists.addAll(currentTodoLists);

    notifyListeners();
  }
  
  void fetchUntrashedTodoList() async {
 
    // READ LIST NOT TRASHED
    final currentNonTrashedTodoLists = isar.todoLists.filter().trashedEqualTo(false).sortByCreatedDesc().findAllSync();
    nonTrashedTodolists.clear();
    nonTrashedTodolists.addAll(currentNonTrashedTodoLists);

    notifyListeners();
  }

  // READ
  void fetchTrashedTodoList() async {
     // READ LIST TRASHED
    final currentTrashedTodoLists = isar.todoLists.filter().trashedEqualTo(true).sortByTrashedDateDesc().findAllSync();
    trashedTodoLists.clear();
    trashedTodoLists.addAll(currentTrashedTodoLists);

    notifyListeners();
  }
  
  // READ STARRED
  void fetchStarredTodoList() async {
    // READ LIST STARRED
    final currentStarredTodoLists = isar.todoLists.filter().trashedEqualTo(false).starredEqualTo(true).sortByStarredDesc().findAllSync();
    starredTodoLists.clear();
    starredTodoLists.addAll(currentStarredTodoLists);

    notifyListeners();
  }

  // UPDATE
  void updateTodoList(int id, plan, category, due, intvl) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.plan = plan;
      existingTodoList.category = category;
      existingTodoList.due = DateTime.parse(due);
      existingTodoList.modified = DateTime.now();
      existingTodoList.interval = intvl;
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
    }

    // Update TodoList List
    fetchTodoList();
  }


  // TRASH
  void trashTodoList(int id) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.trashed = true;
      existingTodoList.trashedDate = DateTime.now();
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
    }

    // Update TodoList List
    fetchTodoList();
  }


  // TRASH ALL
  void trashAllTodoLists(plans) async {
    for (var plan in plans) {
      trashTodoList(plan.id);
    }

    // Update TodoList List
    fetchTodoList();
  }

  
  // DELETE
  void deleteTodoList(int id) async {
    await isar.writeTxn(() => isar.todoLists.delete(id));

    // Update TodoList List
    fetchTodoList();
  }
  
  
  // DELETE ALL
  void deleteAllTodoLists() async {
    await isar.writeTxn(() => isar.todoLists.clear());

    // Update TodoList List
    fetchTodoList();
  }


  // RESTORE PLAN
  void restoreTodoLists(id) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.trashed = false;
      existingTodoList.trashedDate = null;
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
    }

    // Update TodoList List
    fetchTodoList();
  }

  // RESTORE ALL PLANS
  void restoreAllTodoLists(plans) async {
    for (var plan in plans) {
      restoreTodoLists(plan.id);
    }

    // Update TodoList List
    fetchTodoList();
  }

  // COMPLETED
  void completed(int id) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.completed = true;
      existingTodoList.achieved = DateTime.now();
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));

      if (preferences.first.autoDelete == true) {
        trashTodoList(id);
      }
    }

    // Update TodoList List
    fetchTodoList();
  }

  // REPLAN
  void replan(int id) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.completed = false;
      existingTodoList.achieved = null;
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
    }

    // Update TodoList List
    fetchTodoList();
  }

  
  // MAIN SEARCH
  Future<void> search(q) async {
    final currentTodoLists = await isar.todoLists.filter().trashedEqualTo(false).planContains(q, caseSensitive: false).findAll();
    nonTrashedTodolists.clear();
    nonTrashedTodolists.addAll(currentTodoLists);
  }

  // TRASH SEARCH
  Future<void> searchTrash(q) async {
    final currentTodoLists = await isar.todoLists.filter().trashedEqualTo(true).planContains(q, caseSensitive: false).findAll();
    trashedTodoLists.clear();
    trashedTodoLists.addAll(currentTodoLists);
  }

  // STARRED SEARCH
  Future<void> searchStarred(q) async {
    final currentTodoLists = await isar.todoLists.filter().starredEqualTo(true).planContains(q, caseSensitive: false).findAll();
    nonTrashedTodolists.clear();
    nonTrashedTodolists.addAll(currentTodoLists);
  }

  // STAR
  void star(int id) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.starred == true ? existingTodoList.starred = false : existingTodoList.starred = true;
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
    }

    // Update TodoList List
    fetchTodoList();
  }
}