import 'package:get/get.dart';
import 'package:task_manager/project/views/add_sub_task.dart';
import 'package:task_manager/project/views/edit_task.dart';
import 'package:task_manager/project/views/process_detail.dart';
import 'package:task_manager/splash_screen.dart';
import 'package:task_manager/user/views/settings.dart';
import 'package:task_manager/user/views/update_user_profile.dart';
import '../dashboard/views/home_page.dart';
import '../project/views/edit_sub_task.dart';
import '../project/views/project_detail.dart';
import '../project/views/projects.dart';

class AppRoutes {
  static Future? go(String routeName,
          {dynamic arguments, bool preventDuplicates = true}) =>
      Get.toNamed(
        routeName,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
      );

  static void pop() {
    Get.back();
    // bool lastPage = false;
    // Get.until((route) {
    //   if (route.hasActiveRouteBelow) {
    //     return true;
    //   }
    //   lastPage = true;
    //   return true;
    // });
    // if (lastPage) {
    //   // AppRoutes.goAndPopAll(AppRouteName.ROOM);
    // } else {
    //   Get.back();
    // }
  }

  static void pushAndRemoveUntil(
    String name, {
    dynamic arguments,
  }) =>
      Get.offAllNamed(
        name,
        arguments: arguments,
      );
}

class AppRouteName {
  static const String splash = '/splash_screen';
  static const String homePage = '/home_page';
  static const String projectDetail = '/project_detail';
  static const String userProfile = '/user_profile';
  static const String projects = '/projects';
  static const String settings = '/settings';
  static const String editTask = '/edit_task';
  static const String editSubTask = '/edit_sub_task';
  static const String addSubTask = '/add_sub_task';
  static const String processDetail = '/process_detail';

  static final routes = [
    GetPage(
        name: homePage,
        page: () => const HomePage(),
        binding: BindingsBuilder(() {
          // Get.put<HomePageController>(
          //   HomePageController(),
          // );
        })),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: projects, page: () => const Projects()),
    GetPage(name: settings, page: () => const Settings()),
    GetPage(name: userProfile, page: () => const UserProfile()),
    GetPage(
        name: projectDetail,
        page: () => ProjectDetail(
              object: Get.arguments["object"],
            )),
    GetPage(
        name: addSubTask,
        page: () => AddSubTask(
              object: Get.arguments["object"],
            )),
    GetPage(
        name: processDetail,
        page: () => ProcessDetail(
              object: Get.arguments["object"],
              title: Get.arguments["title"],
            )),
    GetPage(
        name: editTask,
        page: () => EditTask(
              object: Get.arguments["object"],
            )),
    GetPage(
        name: editSubTask,
        page: () => EditSubTask(
              object: Get.arguments["object"],
              title: Get.arguments["title"],
              homeObject: Get.arguments["homeObject"],
            )),
  ];
}
