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
  List<TodoList> plans = [];

  /* Handle CRUD operations */

  // CREATE
  void addTodoList(String plan) async {
    final newTodoList = TodoList()..plan = plan..created = DateTime.now();

    // Save to DB
    await isar.writeTxn(() => isar.plans.put(newTodoList));
    
    // Update TodoList List
    fetchTodoList();
  }


  // READ
  void fetchTodoList() async {
    final currentTodoLists = isar.plans.where().findAllSync();
    plans.clear();
    plans.addAll(currentTodoLists);
    notifyListeners();
  }

  // UPDATE
  void updateTodoList(int id, String plan) async {
    var existingTodoList = await isar.plans.get(id);
    if (existingTodoList != null) {
      existingTodoList.plan = plan;
      await isar.writeTxn(() => isar.plans.put(existingTodoList));
    }

    // Update TodoList List
    fetchTodoList();
  }


  // DELETE
  void deleteTodoList(int id) async {
    await isar.writeTxn(() => isar.plans.delete(id));

    // Update TodoList List
    fetchTodoList();
  }


  // DELETE ALL
  void deleteAllTodoLists() async {
    await isar.writeTxn(() => isar.plans.clear());

    // Update TodoList List
    fetchTodoList();
  }
}