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
  List<TodoList> todolists = [];

  /* Handle CRUD operations */

  // CREATE
  void addTodoList(plan, category, due) async {
    final newTodoList = TodoList()..plan = plan..category = category..completed = false..favorite = false..created = DateTime.now()..due = DateTime.parse(due);

    // Save to DB
    await isar.writeTxn(() => isar.todoLists.put(newTodoList));
    
    // Update TodoList List
    fetchTodoList();
  }


  // READ
  void fetchTodoList() async {
    final currentTodoLists = isar.todoLists.where().findAllSync();
    todolists.clear();
    todolists.addAll(currentTodoLists);
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
    var max = await isar.writeTxn(() => isar.todoLists.count());
    for (var id = 0; id <= max; id++) {
      var existingTodoList = await isar.todoLists.get(id);
      if (existingTodoList != null) {
        existingTodoList.trashed = true;
        existingTodoList.trashedDate = DateTime.now();
        await isar.writeTxn(() => isar.todoLists.put(existingTodoList));
      }
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

  
   // REPLAN
  Future<void> search(q) async {
    final currentTodoLists = await isar.todoLists.filter().planContains(q, caseSensitive: false).findAll();
    todolists.clear();
    todolists.addAll(currentTodoLists);
  }
}