import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/models/note_database.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NoteOptions extends StatelessWidget {
  final int id;
  final String note;

  const NoteOptions({
    super.key,
    required this.id,
    required this.note
  });

  @override
  Widget build(BuildContext context) {
    // Access user input
    final textController = TextEditingController();

    // Update
    void editNote(int id, note) {
      textController.text = note;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                String text = textController.text;
                if (text.isNotEmpty) {
                  context.read<NoteDatabase>().updateNote(id, text);
                  Navigator.pop(context);
                  textController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Updated and fresh!',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                }
              }
            )
          ],
        )
      );
    }

    // Delete
    void deleteNote(int id) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "Delete Note?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Quicksand',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<NoteDatabase>().deleteNote(id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Poof! Gone like the wind',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
              },
              icon: const Icon(
                Icons.done,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel_outlined,
              ),
            ),
          ],
        ) 
      );
    }

    // Miscellaneous

    // Share Note
    void share(String note) {
      Share.share(note);
    }

    void copy(String note) {
      Clipboard.setData (
        ClipboardData(
          text: note
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Copied and locked! Paste at your leisure!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold
            )
          )));
    }
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            editNote(id, note);
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            copy(note);
          },
          icon: const Icon(
            Icons.copy,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            share(note);
          },
          icon: const Icon(
            Icons.share,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            deleteNote(id);
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}