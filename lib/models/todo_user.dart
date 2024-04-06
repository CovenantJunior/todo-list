import 'package:isar/isar.dart';

// Generate collection file by running `dart run build_runner build`
part 'todo_user.g.dart';

@Collection()
class TodoUser {
  Id id = Isar.autoIncrement;
  String? username;
  String? email;
  DateTime? createdAt;

  // Authentication fields
  String? googleUserId;
  String? authToken;

  // Backup fields
  DateTime? lastBackup;
}