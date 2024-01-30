import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:path_provider/path_provider.dart';

class TodoListDatabase extends ChangeNotifier{
  static late Isar isar;

  // Initialize DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoListSchema],
      directory: dir.path
    );
  }

  // List of all TodoLists
  // List<TodoList> todolists = [];

  List<TodoList> nonTrashedTodolists = [];

  List<TodoList> nonStarredTodolists = [];

  List<TodoList> trashedTodoLists = [];

  List<TodoList> starredTodoLists = [];

  /* Handle CRUD operations */

  // CREATE
  void addTodoList(plan, category, due) async {
    final newTodoList = TodoList()..plan = plan..category = category..completed = false..created = DateTime.now()..due = DateTime.parse(due)..starred = false..trashed = false;

    // Save to DB
    await isar.writeTxn(() => isar.todoLists.put(newTodoList));
    
    // Update TodoList List
    fetchTodoList();
  }


  // READ
  void fetchTodoList() async {
 
    // READ LIST NOT TRASHED
    final currentNonTrashedTodoLists = isar.todoLists.filter().trashedEqualTo(false).findAllSync();
    nonTrashedTodolists.clear();
    nonTrashedTodolists.addAll(currentNonTrashedTodoLists);
    
    notifyListeners();
  }

  // READ
  void fetchTrashedTodoList() async {
     // READ LIST TRASHED
    final currentTrashedTodoLists = isar.todoLists.filter().trashedEqualTo(true).findAllSync();
    trashedTodoLists.clear();
    trashedTodoLists.addAll(currentTrashedTodoLists);
    
    notifyListeners();
  }
  
  // READ STARRED
  void fetchStarredTodoList() async {
    // READ LIST STARRED
    final currentStarredTodoLists = isar.todoLists.filter().starredEqualTo(true).findAllSync();
    starredTodoLists.clear();
    starredTodoLists.addAll(currentStarredTodoLists);
    notifyListeners();
  }

  // UPDATE
  void updateTodoList(int id, plan, category, due) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.plan = plan;
      existingTodoList.category = category;
      existingTodoList.due = DateTime.parse(due);
      existingTodoList.modified = DateTime.now();
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
  void trashAllTodoLists() async {
    var allexistingTodoList = isar.todoLists.where().findAllSync();
    for (var existingTodoList in allexistingTodoList) {
      existingTodoList.trashed = true;
      existingTodoList.trashedDate = DateTime.now();
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
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

  // COMPLETED
  void completed(int id) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.completed = true;
      existingTodoList.achieved = DateTime.now();
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
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

    // Update TodoList List
    fetchTodoList();
  }

  // TRASH SEARCH
  Future<void> searchTrash(q) async {
    final currentTodoLists = await isar.todoLists.filter().trashedEqualTo(true).planContains(q, caseSensitive: false).findAll();
    trashedTodoLists.clear();
    trashedTodoLists.addAll(currentTodoLists);

    // Update TodoList List
    fetchTodoList();
  }

  // STARRED SEARCH
  Future<void> searchStarred(q) async {
    final currentTodoLists = await isar.todoLists.filter().starredEqualTo(true).planContains(q, caseSensitive: false).findAll();
    nonTrashedTodolists.clear();
    nonTrashedTodolists.addAll(currentTodoLists);

    // Update TodoList List
    fetchTodoList();
  }

  // STAR
  void star(int id) async {
    var existingTodoList = await isar.todoLists.get(id);
    if (existingTodoList != null) {
      existingTodoList.starred = true;
      await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
    }

    // Update TodoList List
    fetchTodoList();
  }
}