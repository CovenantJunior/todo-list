import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:note_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier{
  static late Isar isar;

  // Initialize DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path
    );
  }

  // List of all Notes
  List<Note> notes = [];

  /* Handle CRUD operations */

  // CREATE
  void addNote(String note) async {
    final newNote = Note()..note = note..created = DateTime.now();

    // Save to DB
    await isar.writeTxn(() => isar.notes.put(newNote));
    
    // Update Note List
    fetchNote();
  }


  // READ
  void fetchNote() async {
    final currentNotes = isar.notes.where().findAllSync();
    notes.clear();
    notes.addAll(currentNotes);
    notifyListeners();
  }

  // UPDATE
  void updateNote(int id, String note) async {
    var existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.note = note;
      await isar.writeTxn(() => isar.notes.put(existingNote));
    }

    // Update Note List
    fetchNote();
  }


  // DELETE
  void deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));

    // Update Note List
    fetchNote();
  }


  // DELETE ALL
  void deleteAllNotes() async {
    await isar.writeTxn(() => isar.notes.clear());

    // Update Note List
    fetchNote();
  }
}