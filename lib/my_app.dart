import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/nav_bar_items.dart';
import 'modules/dashboard/views/dashboard.dart';
import 'modules/notepad/views/notepad.dart';
import 'modules/project/views/add_project.dart';
import 'modules/project/views/projects.dart';
import 'modules/user/views/user_profile.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isExist;

  List<Widget> _buildScreens() {
    return [
      const Dashboard(),
      const Projects(),
      const AddProject(),
      const NotePad(),
      UserProfile(
        isOldUser: isExist == true ? true : false,
      )
    ];
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  void isProfileExist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('name')) {
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style15,
      );
}
