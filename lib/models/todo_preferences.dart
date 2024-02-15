import 'package:isar/isar.dart';

// Generate collection file by running `dart run build_runner build`
part 'todo_preferences.g.dart';

@Collection()
class TodoPreferences {
  Id id = Isar.autoIncrement;
  bool? darkMode;
  bool? notification;
  bool? vibration;
  bool? stt;
  bool? readPlan;
  bool? backup;
  bool? autoSync;
  bool? accessClipboard;
  bool? autoDelete;
  bool? autoDeleteOnDismiss;
}