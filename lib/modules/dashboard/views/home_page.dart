import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/shared_prefs/shared_prefs.dart';
import '../../../app_utils/global_data.dart';
import '../../user/views/user_profile.dart';
import '../controller/dashboard_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  DashboardController dashboardController = Get.put(DashboardController());
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void isProfileExist() async {
    if (SharedPrefs.getBool(SharedPrefs.isLoggedIn)==true) {
      dashboardController.screens.value.insert(
          4,
          const UserProfile(
            isOldUser: true,
          ));
    } else {
      dashboardController.screens.value.insert(
          4,
          const UserProfile(
            isOldUser: false,
          ));
    }
  }

  void onTap(int index) {
    dashboardController.oldIndex.value = selectIndex.value;
    selectIndex.value = index;
  }

  void onPageChanged(int index) {
    selectIndex.value = index;
  }

  @override
  initState() {
    isProfileExist();
    super.initState();
  }

  ValueListenableBuilder transition() {
    if (dashboardController.oldIndex.value < selectIndex.value) {
      dashboardController.position.value = 1.0;
    } else {
      dashboardController.position.value = -1.0;
    }
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = CurvedAnimation(curve: Curves.easeIn, parent: controller);
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return Obx(() => AnimatedSwitcher(
              switchOutCurve: Curves.decelerate,
              reverseDuration: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 450),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  SlideTransition(
                position: Tween(
                  begin: Offset(dashboardController.position.value, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: child,
              ),
              child: dashboardController.screens.value[selectIndex.value],
            ));
      },
      valueListenable: selectIndex,
    );
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: selectIndex,
      builder: (context, value, child) {
        return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectIndex.value,
                type: BottomNavigationBarType.fixed,
                onTap: onTap,
                iconSize: 27,
                selectedLabelStyle: TextStyle(color: Colors.red[200]),
                selectedFontSize: 0,
                selectedItemColor: Colors.red[200],
                unselectedFontSize: 1,
                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.home,
                      ),
                      label: ''),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.doc,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: CircleAvatar(
                        backgroundColor: Colors.red[200],
                        child: Icon(
                          CupertinoIcons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      label: ''),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.news,
                      ),
                      label: ''),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.person,
                      ),
                      label: ''),
                ]),
            body: transition());
      });
}
