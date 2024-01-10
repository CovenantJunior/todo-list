import 'package:flutter/material.dart';
import 'package:note_app/component/note_drawer_tile.dart';
import 'package:note_app/layouts/note_settings.dart';
import 'package:note_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NoteDrawer extends StatefulWidget {
  const NoteDrawer({super.key});

  @override
  State<NoteDrawer> createState() => _NoteDrawerState();
}

class _NoteDrawerState extends State<NoteDrawer> {
  // Delete All Notes
    void deleteAllNotes() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "Delete all Notes?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Quicksand',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<NoteDatabase>().deleteAllNotes();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Poof! Gone like the wind',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                Navigator.pop(context);
                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    List notes = context.watch<NoteDatabase>().notes;
    
    return Drawer(
      semanticLabel: "Note Drawer Menu",
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(
                'images/note.png',
                width: 70,
              ),
          ),
          NoteDrawerTile(
            title: "Home",
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            }
          ),

          NoteDrawerTile(
            title: "Settings",
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteSettings()));
            }
          ),

          if (notes.isNotEmpty)
            NoteDrawerTile(
              title: "Clean All Notes",
              leading: const Icon(Icons.delete_forever_rounded),
              onTap: () {
                deleteAllNotes();
              },
            ),
        ],
      ),
    );
  }
}