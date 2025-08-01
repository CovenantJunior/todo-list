import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/todo_list.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
class Shell extends StatefulWidget {
  final int index;
  late List nonTrashedTodolists;
  late List cardToRemove;
  late bool animate;
  late bool isSearch;
  late bool isOfLength;
  late String selectedCategory;
  Function closeSearch;
  Function toggle;

  Shell({
    super.key,
    required this.index,
    required this.nonTrashedTodolists,
    required this.cardToRemove,
    required this.animate,
    required this.isSearch,
    required this.isOfLength,
    required this.selectedCategory,
    required this.closeSearch,
    required this.toggle
  });

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {

  int index = 0;
  late bool exit;

  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController(initialIndex: widget.index);
    return Tooltip(
      message: index == 0 ? 'All' : widget.selectedCategory,
      child: PersistentTabView(
        backgroundColor: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.white : Colors.black,
        context,
        controller: controller,
        onItemSelected: (e) {
          switch (e) {
            case 0:
              widget.toggle('All');
              break;
            case 1:
              widget.toggle('Personal');
              break;
            case 2:
              widget.toggle('Work');
              break;
            case 3:
              widget.toggle('Study');
              break;
            case 4:
              widget.toggle('Shopping');
              break;
            case 5:
              widget.toggle('Sport');
            break;
            default:
          }
          setState(() {
            index = e;
          });
        },
        onWillPop: (p0) {
          if (exit) {
            FlutterExitApp.exitApp();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Press back again to exit',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              duration: Duration(seconds: 3)
            ),
          );
          exit = true;
          Future.delayed(const Duration(seconds: 3), (){
            exit = false;
          });
          return Future.value(false);
        },
        screens: [
          Todo(
            list: widget.nonTrashedTodolists,
            category: 'All',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: widget.closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Personal',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: widget.closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Work',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: widget.closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Study',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: widget.closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Shopping',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: widget.closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Sport',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: widget.closeSearch
          ),
        ],
        items: [
          PersistentBottomNavBarItem(
            activeColorPrimary: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
            icon: Icon(
              Icons.home_outlined,
              color: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
              size: 20,
            ),
            title: ("All"),
            textStyle: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
            icon: Icon(
              Icons.person_2_outlined,
              color: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
              size: 20,
            ),
            title: ("Personal"),
            textStyle: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
            icon: Icon(
              Icons.work_outline_rounded,
              color: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
              size: 20,
            ),
            title: ("Work"),
            textStyle: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
            icon: Icon(
              Icons.book_outlined,
              color: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
              size: 20,
            ),
            title: ("Study"),
            textStyle: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
            icon: Icon(
              Icons.shopping_basket_outlined,
              color: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
              size: 20,
            ),
            title: ("Shopping"),
            textStyle: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
            icon: Icon(
              Icons.sports_soccer_rounded,
              color: !context.watch<TodoListDatabase>().preferences.first.darkMode ? Colors.black87 : Colors.white,
              size: 20,
            ),
            title: ("Sport"),
            textStyle: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          )
        ],
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardAppears: true,
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
        padding: const EdgeInsets.only(top: 8),
        isVisible: true,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: kBottomNavigationBarHeight,
        navBarStyle: NavBarStyle.style19 // Choose the nav bar style with this property
      ),
    );
  }
}
