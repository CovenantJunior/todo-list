import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/services/ads/interstitial.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:vibration/vibration.dart';

class TodoListTrashOptions extends StatefulWidget {
  final int id;
  final String plan;
  // ignore: non_constant_identifier_names
  final TodoList Plan;

  const TodoListTrashOptions({
    super.key,
    required this.id,
    required this.plan,
    // ignore: non_constant_identifier_names
    required this.Plan
  });

  @override
  State<TodoListTrashOptions> createState() => _TodoListTrashOptionsState();
}

class _TodoListTrashOptionsState extends State<TodoListTrashOptions> {
  @override
  Widget build(BuildContext context) {

    // InterstitialAds().loadInterstitialAd(context);

      // Delete Forever
      void deleteTodoList(int id) {
        context.read<TodoListDatabase>().preferences.first.vibration == true ? Vibration.vibrate(duration: 50) : null;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text(
              "Delete Plan Forever?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Quicksand',
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<TodoListDatabase>().deleteTodoList(id);
                  NotificationService().cancelNotification(id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                      ),
                    duration: const Duration(seconds: 2),
                    content: const Text(
                      'Poof! Gone like the wind',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500
                      )
                    )
                  ));
                  InterstitialAds().loadInterstitialAd(context);
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

      void restore(int id) {
        context.read<TodoListDatabase>().restoreTodoLists(id);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)
            ),
            duration: const Duration(seconds: 2),
            content: const Text(
              'Restored back on track',
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500
              )
            )
          )
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message: "Restore",
            child: IconButton(
              onPressed: () {
                restore(widget.Plan.id);
              },
              icon: const Icon(
              Icons.restore_rounded,
              color: Colors.blueGrey,
            )
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTodoList(widget.Plan.id);
            },
            icon: const Tooltip(
              message: "Delete Plan Forever",
              child: Icon(
                Icons.delete_forever_rounded,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      );
  }
}