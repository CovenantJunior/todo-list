import 'package:isar/isar.dart';

// Generate collection file by running `dart run build_runner build`
part 'todo_list.g.dart';

@Collection()
class TodoList {
  Id id = Isar.autoIncrement;
  String? plan;
  String? category;
  bool? completed;
  DateTime? created;
  DateTime? modified;
  DateTime? due;
  DateTime? achieved;
  bool? starred;
  bool? trashed;
  DateTime? trashedDate;
}