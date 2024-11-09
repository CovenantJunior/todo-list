import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:todo_list/component/todo_list.dart';
class Shell extends StatefulWidget {
  final int index;
  late List nonTrashedTodolists;
  late List cardToRemove;
  late bool animate;
  late bool isSearch;
  late bool isOfLength;
  late String selectedCategory;

  Shell({
    super.key,
    required this.index,
    required this.nonTrashedTodolists,
    required this.cardToRemove,
    required this.animate,
    required this.isSearch,
    required this.isOfLength,
    required this.selectedCategory
  });

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {

  void closeSearch() {
    setState(() {
      widget.isSearch = false;
      widget.isOfLength = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController(initialIndex: widget.index);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: PersistentTabView(
        context,
        controller: controller,
        screens: [
          Todo(
            list: widget.nonTrashedTodolists,
            category: 'All',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Personal',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Work',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Study',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Shopping',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: closeSearch
          ),
        Todo(
            list: widget.nonTrashedTodolists,
            category: 'Sport',
            cardToRemove: widget.cardToRemove,
            animate: widget.animate,
            isSearch: widget.isSearch,
            isOfLength: widget.isOfLength,
            selectedCategory: widget.selectedCategory,
            closeSearch: closeSearch
          ),
        ],
        items: [
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 20,
            ),
            title: ("All"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.person_2_outlined,
              color: Colors.white,
              size: 20,
            ),
            title: ("Personal"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.work_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            title: ("Work"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.book_outlined,
              color: Colors.white,
              size: 20,
            ),
            title: ("Study"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.shopping_basket_outlined,
              color: Colors.white,
              size: 20,
            ),
            title: ("Shopping"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.sports_soccer_rounded,
              color: Colors.white,
              size: 20,
            ),
            title: ("Sport"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
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
        backgroundColor: Colors.black,
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
        navBarStyle: NavBarStyle.style9 // Choose the nav bar style with this property
      ),
    );
  }
}
