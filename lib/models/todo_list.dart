import 'package:isar/isar.dart';

// Generate collection file by running `dart run build_runner build`
part 'note.g.dart';

@Collection()
class List {
  Id id = Isar.autoIncrement;
  String? note;
  bool? completed;
  DateTime? created;
  DateTime? modified;
}