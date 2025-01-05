import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_list/component/todo_list_drawer_tile.dart';
import 'package:todo_list/layouts/todo_list_about.dart';
import 'package:todo_list/layouts/todo_list_preferences.dart';
import 'package:todo_list/layouts/todo_list_privacy.dart';
import 'package:todo_list/layouts/todo_list_starred.dart';
import 'package:todo_list/layouts/todo_trash_page.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';

class TodoListDrawer extends StatefulWidget {
  const TodoListDrawer({super.key});

  @override
  State<TodoListDrawer> createState() => _TodoListDrawerState();
}

class _TodoListDrawerState extends State<TodoListDrawer> {
  @override
  Widget build(BuildContext context) {
    
    context.read<TodoListDatabase>().fetchUser();
    List user = context.watch<TodoListDatabase>().user;
    
    return Drawer(
      semanticLabel: "TodoList Drawer Menu",
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.isEmpty || user.first.googleUserPhotoUrl == '' ? Image.asset(
                    'assets/images/note.png',
                    width: 70,
                    height: 70,
                  ) : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                       child: CachedNetworkImage(
                        width: 70,
                        height: 70,
                        imageUrl: user.first.googleUserPhotoUrl,
                        placeholder: (context, url) => const CircularProgressIndicator(
                          value: null,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                        ),
                        errorWidget: (context, url, error) => const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/note.png'),
                          backgroundColor: Colors.transparent,
                          radius: 50,
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                          backgroundColor: Colors.transparent,
                          radius: 50,
                        ),
                      )
                  ),
                ),
                user.isEmpty || user.first.username == '' ? const SizedBox() : Text(user.first.username, style: const TextStyle(fontFamily: 'Quicksand'),)
              ]
              )
            ),

            TodoListDrawerTile(
              title: "Home",
              leading: const Icon(Icons.home_outlined),
              onTap: () {
                Navigator.pop(context);
              }
            ),

            TodoListDrawerTile(
              title: "Starred",
              leading: const Icon(Icons.star_border_rounded),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoStarred()));
              }
            ),
        
            TodoListDrawerTile(
              title: "Preferences",
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoListPreferences()));
              }
            ),
        
            /* if (todolists.isNotEmpty && nonTrashedTodolists.isNotEmpty)
              TodoListDrawerTile(
                title: "Move all to Trash",
                leading: const Icon(Icons.delete_sweep_outlined),
                onTap: () {
                  trashAllTodoLists();
                },
              ), */

            TodoListDrawerTile(
              title: "Trash",
              leading: const Icon(Icons.delete_outline_rounded),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoTrash()));
              }
            ),

            /* Provider.of<TodoListDatabase>(context).preferences.first.autoSync == false ? TodoListDrawerTile(
              title: "Backup",
              leading: const Icon(Icons.backup_outlined),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoTrash()));
              }
            ) : const SizedBox(), */
            
            TodoListDrawerTile(
              title: "Rate",
              leading: const Icon(Icons.rate_review_outlined),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoTrash()));
              }
            ),

            TodoListDrawerTile(
              title: "Invite Friends",
              leading: const Icon(Icons.people_outline_rounded),
              onTap: () {
                Navigator.pop(context);
                Share.share("Checkout this cool app:");
              }
            ),

            TodoListDrawerTile(
              title: "About",
              leading: const Icon(Icons.info_outline_rounded),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoAbout()));
              }
            ),

            TodoListDrawerTile(
              title: "Privacy Policy",
              leading: const Icon(Icons.privacy_tip_outlined),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoPrivacy()));
              }
            ),

            TodoListDrawerTile(
              title: "Remove Ads",
              leading: const Icon(Icons.movie_filter_outlined),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoPrivacy()));
              }
            ),
          ],
        ),
      ),
    );
  }
}