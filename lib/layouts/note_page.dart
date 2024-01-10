import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:note_app/component/note_drawer.dart';
import 'package:note_app/component/note_options.dart';
// import 'package:note_app/component/note_options.dart';
import 'package:note_app/models/note_database.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // Access user input
  final textController = TextEditingController();

  // Create
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a Note Title"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            // color: Colors.blueGrey,
            onPressed: () {
              String text = textController.text;
              if (text.isNotEmpty) {
                context.read<NoteDatabase>().addNote(text);
                Navigator.pop(context);
                textController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
                    'Note secured',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
                    'Oops, blank shot!',
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

  // Read
  Future<void> readNotes() async {
    context.read<NoteDatabase>().fetchNote();
  }

  @override
  Widget build(BuildContext context) {
    List notes = context.watch<NoteDatabase>().notes;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Notes",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
            SizedBox(width: 3),
            Icon(
              Icons.bookmark_added_rounded,
              // color: Colors.blueGrey,
            ),
          ],
        ),
        centerTitle: true,
      ),

      drawer: const NoteDrawer(),

      body: notes.isNotEmpty  ? LiquidPullToRefresh(
        onRefresh: () async {
          readNotes();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
            final note = notes[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      note.note,
                      overflow: TextOverflow.clip,
                      maxLines: 20,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: () {
                            showPopover(
                              width: 270,
                              context: context,
                              bodyBuilder: (context) => NoteOptions(id: note.id, note: note.note)
                            );
                          },
                          icon: const Icon(
                            Icons.more_vert, 
                            color:Colors.blueGrey
                          )
                        );
                      }
                    ),
                    /* NoteOptions(
                      id: note.id,
                      note: note.note
                    ) */
                  ],
                ),
              ),
            );
          }),
        ),
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              const Center(child: Text(
                  "No notes yet, tap the icon below to add",
                  style: TextStyle(
                    // color: Colors.blueGrey,
                  ),
                )
              ),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.only(left: 230.0),
                child: Transform.rotate(
                  angle: 1.5708,
                  child: Image.asset(
                    'images/pointer.gif',
                    width: 100,
                  )
                ),
              )
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        child: const Icon(
          Icons.add,
          // color: Colors.blueGrey,
        ),
      ),
    );
  }
}