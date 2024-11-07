import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:todo_list/tabs/home.dart';
class Shell extends StatelessWidget {
  final int index;

  const Shell({
    super.key,
    required this.index
  });


  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController(initialIndex: index);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: PersistentTabView(
        context,
        controller: controller,
        screens: const [
          Home(),
          Home(),
          Home(),
          Home(),
          Home(),
          Home(),
        ],
        items: [
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.download_done_rounded,
              color: Colors.white,
              size: 20,
            ),
            title: ("Downloads"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.downhill_skiing_rounded,
              color: Colors.white,
              size: 20,
            ),
            title: ("Surf"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 20,
            ),
            title: ("Settings"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.download_done_rounded,
              color: Colors.white,
              size: 20,
            ),
            title: ("Downloads"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.downhill_skiing_rounded,
              color: Colors.white,
              size: 20,
            ),
            title: ("Surf"),
            textStyle: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 10
            )
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.white,
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 20,
            ),
            title: ("Settings"),
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
