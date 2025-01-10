import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/models/todo_preferences.dart';
import 'package:todo_list/models/todo_user.dart';

class BackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static late Isar isar;


  /* BACKUP USER DATA AFTER AUTHENTICATION*/
  Future<void> backupUserData(context, {required backup}) async {

    // Fetch User
    context.read<TodoListDatabase>().fetchUser();

    // Assign all the variables from the context.read<TodoListDatabase>() to the variables user, todoLists, and preferences.
    List user = context.read<TodoListDatabase>().user;
    List<TodoList> todoLists = context.read<TodoListDatabase>().todolists;
    List preferences = context.read<TodoListDatabase>().preferences;

    try {
      // Backup user data
      await _firestore.collection('users').doc(user.first.googleUserId.toString()).set({
        'username': user.first.username,
        'email': user.first.email,
        'pro': user.first.pro,
        'createdAt': user.first.createdAt?.toIso8601String(),
        'googleUserId': user.first.googleUserId,
        'googleUserPhotoUrl': user.first.googleUserPhotoUrl,
        'lastBackup': user.first.lastBackup?.toIso8601String(),
      });

      // Backup todo lists
      for (var todo in todoLists) {
        await _firestore.collection('users').doc(user.first.googleUserId.toString()).collection('todoLists').doc(todo.id.toString()).set({
          'plan': todo.plan,
          'category': todo.category,
          'completed': todo.completed,
          'created': todo.created?.toIso8601String(),
          'modified': todo.modified?.toIso8601String(),
          'due': todo.due?.toIso8601String(),
          'achieved': todo.achieved?.toIso8601String(),
          'starred': todo.starred,
          'trashed': todo.trashed,
          'trashedDate': todo.trashedDate?.toIso8601String(),
          'interval': todo.interval,
        });
      }

      // Backup preferences
      await _firestore.collection('users').doc(user.first.googleUserId.toString()).collection('preferences').doc(preferences.first.id.toString()).set({
        'darkMode': preferences.first.darkMode,
        'notification': preferences.first.notification,
        'vibration': preferences.first.vibration,
        'stt': preferences.first.stt,
        'backup': preferences.first.backup,
        'autoSync': preferences.first.autoSync,
        'accessClipboard': preferences.first.accessClipboard,
        'autoDelete': preferences.first.autoDelete,
        'autoDeleteOnDismiss': preferences.first.autoDeleteOnDismiss,
        'bulkTrash': preferences.first.bulkTrash,
      });
    } catch (e) {
      print('Error backing up data: $e');
    }
  }


  /* IMPORT USER DATA AFTER AUTHENTICATION*/
  Future<void> importUserData(String userId) async {
    try {
      // Fetch user data
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      TodoUser user = TodoUser()
        ..id = int.parse(userId)
        ..username = userDoc['username']
        ..email = userDoc['email']
        ..pro = userDoc['pro']
        ..createdAt = DateTime.parse(userDoc['createdAt'])
        ..googleUserId = userDoc['googleUserId']
        ..googleUserPhotoUrl = userDoc['googleUserPhotoUrl']
        ..lastBackup = DateTime.parse(userDoc['lastBackup']);

      // Fetch todo lists
      QuerySnapshot todoListSnapshot = await _firestore.collection('users').doc(userId).collection('todoLists').get();
      List<TodoList> todoLists = todoListSnapshot.docs.map((doc) {
        return TodoList()
          ..id = int.parse(doc.id)
          ..plan = doc['plan']
          ..category = doc['category']
          ..completed = doc['completed']
          ..created = DateTime.parse(doc['created'])
          ..modified = DateTime.parse(doc['modified'])
          ..due = DateTime.parse(doc['due'])
          ..achieved = DateTime.parse(doc['achieved'])
          ..starred = doc['starred']
          ..trashed = doc['trashed']
          ..trashedDate = DateTime.parse(doc['trashedDate'])
          ..interval = doc['interval'];
      }).toList();

      // Fetch preferences
      DocumentSnapshot preferencesDoc = await _firestore.collection('users').doc(userId).collection('preferences').doc(userId).get();
      TodoPreferences preferences = TodoPreferences()
        ..id = int.parse(userId)
        ..darkMode = preferencesDoc['darkMode']
        ..notification = preferencesDoc['notification']
        ..vibration = preferencesDoc['vibration']
        ..stt = preferencesDoc['stt']
        ..backup = preferencesDoc['backup']
        ..autoSync = preferencesDoc['autoSync']
        ..accessClipboard = preferencesDoc['accessClipboard']
        ..autoDelete = preferencesDoc['autoDelete']
        ..autoDeleteOnDismiss = preferencesDoc['autoDeleteOnDismiss']
        ..bulkTrash = preferencesDoc['bulkTrash'];

      // Save data to Isar
      await isar.writeTxn(() async {
        await isar.todoUsers.put(user);
        await isar.todoLists.putAll(todoLists);
        await isar.todoPreferences.put(preferences);
      });
    } catch (e) {
      print('Error importing data: $e');
    }
  }
}