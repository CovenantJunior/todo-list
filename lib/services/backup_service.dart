import 'dart:io' as fa;

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:todo_list/models/todo_list.dart';
// import 'package:todo_list/models/todo_preferences.dart';

class Backup {
  Isar? isar;

  DateTime date = DateTime.now();

  void backup(context, {required backup}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7)
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed,
        content: const Text('Backing up...',
          style: TextStyle(
            fontFamily: "Quicksand", fontWeight: FontWeight.w500
          )
        ),
      ),
    );
    final dir = await getApplicationDocumentsDirectory();
    isar = Isar.getInstance();
    fa.File file = fa.File("${dir.path}/minimalist.isar");
    if (await file.exists()) {
      await file.delete();
    }
    await isar?.copyToFile(file.path);
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        duration: const Duration(seconds: 1),
        content: const Text('Backup completed',
          style: TextStyle(
              fontFamily: "Quicksand", fontWeight: FontWeight.w500)
            ),
      )
    );
    backup();
  }
}