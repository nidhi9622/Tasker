import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/dashboard.dart';
import 'package:task_manager/projects.dart';
import 'package:task_manager/splashScreen.dart';
import 'package:task_manager/userProfile.dart';
import 'addProject.dart';
import 'localString.dart';
import 'newUserProfile.dart';
import 'notepad.dart';

void requestIOSPermissions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? status = true;
  status = preferences.getBool('theme');
  preferences.setInt('id', 0);
  requestIOSPermissions(FlutterLocalNotificationsPlugin());
  await Permission.camera.request();
  await Permission.photos.request();
  runApp(GetMaterialApp(
      themeMode: status == true ? ThemeMode.dark : ThemeMode.light,
      translations: LocalString(),
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.black54,
        scaffoldBackgroundColor: const Color(0xffededed),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        primaryColorDark: Colors.white,
        primaryColorLight: Colors.white70,
        scaffoldBackgroundColor: const Color(0xff363535),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: const SplashScreen()));
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: ("Home"),
      activeColorPrimary: const Color(0xFFEA9A9A),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.doc),
      title: ("Projects"),
      activeColorPrimary: const Color(0xFFEA9A9A),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        CupertinoIcons.add,
        color: Colors.white,
      ),
      title: ("Add"),
      activeColorPrimary: const Color(0xFFEA9A9A),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.news),
      title: ("Notepad"),
      activeColorPrimary: const Color(0xFFEA9A9A),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.profile_circled),
      title: ("Profile"),
      activeColorPrimary: const Color(0xFFEA9A9A),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
}

class MyApp extends StatefulWidget {
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
      isExist == true ? const Profile() : const NewUserProfile()
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
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
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
}
