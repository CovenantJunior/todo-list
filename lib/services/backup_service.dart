import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
// import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/models/todo_preferences.dart';
import 'package:todo_list/models/todo_user.dart';

class BackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static late Isar isar;


  /* BACKUP USER DATA AFTER AUTHENTICATION*/
  Future<void> backupUserData(context, user, todoLists, preferences, backup) async {
    // print('Backing up...');
    // print(user.email);

    if (user.googleUserId == null || user.googleUserId.isEmpty) {
      // print('Error: googleUserId is null or empty');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        duration: const Duration(seconds: 1),
        content: const Row(children: [
          Icon(Icons.error_outline_rounded, color: Colors.red),
          SizedBox(width: 10),
          Text('Backup failed: Invalid user ID',
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
        ]),
      ));
      backup();
      return;
    }

    try {
      // Backup user data
      // print('Backup user profile...');
      await _firestore.collection('users').doc(user.googleUserId.toString()).set({
        'username': user.username,
        'email': user.email,
        'pro': user.pro,
        'createdAt': user.createdAt?.toIso8601String(),
        'googleUserId': user.googleUserId,
        'googleUserPhotoUrl': user.googleUserPhotoUrl,
        'lastBackup': user.lastBackup?.toIso8601String(),
      });


      // Backup preferences
      // print('Backup user preferences...');
      await _firestore.collection('users').doc(user.googleUserId.toString()).collection('preferences').doc(preferences.id.toString()).set({
        'darkMode': preferences.darkMode,
        'notification': preferences.notification,
        'vibration': preferences.vibration,
        'stt': preferences.stt,
        'backup': preferences.backup,
        'autoSync': preferences.autoSync,
        'accessClipboard': preferences.accessClipboard,
        'autoDelete': preferences.autoDelete,
        'autoDeleteOnDismiss': preferences.autoDeleteOnDismiss,
        'bulkTrash': preferences.bulkTrash,
      });

      
      if(todoLists.isEmpty) {
        // print('No todo lists to backup');
      } else {
        // Backup todo lists
        // print('Backup user todolists...');
        for (var todo in todoLists) {
          await _firestore.collection('users').doc(user.googleUserId.toString()).collection('todoLists').doc(todo.id.toString()).set({
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
      }
      
      
      // print('Backup successful');
      // Show success message if sign-in works
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        duration: const Duration(seconds: 5),
        content: const Row(children: [
          Icon(Icons.check_circle_outline_rounded, color: Colors.green),
          SizedBox(width: 10),
          Text('Data synced',
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
        ]),
      ));
    } catch (e) {
      // Show error message if sign-in fails
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        duration: const Duration(seconds: 5),
        content: const Row(children: [
          Icon(Icons.error_outline_rounded, color: Colors.red),
          SizedBox(width: 10),
          Text('Backup failed',
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
        ]),
      ));
      // print('Error backing up data: $e');
    } finally {
      // Call backup() to update the parent widget's state
      backup();
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
      // print('Error importing data: $e');
    }
  }
}