import 'package:isar/isar.dart';

// Generate collection file by running `dart run build_runner build`
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  String? note;
  DateTime? created;
  DateTime? modified;
}