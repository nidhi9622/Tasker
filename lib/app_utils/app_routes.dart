import 'package:get/get.dart';
import '../modules/dashboard/views/home_page.dart';
import '../modules/project/views/add_sub_task.dart';
import '../modules/project/views/edit_sub_task.dart';
import '../modules/project/views/edit_task.dart';
import '../modules/project/views/process_detail.dart';
import '../modules/project/views/project_detail.dart';
import '../modules/project/views/projects.dart';
import '../modules/user/views/settings.dart';
import '../modules/user/views/update_user_profile.dart';
import '../splash_screen.dart';

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
  static const String updateUserProfile = '/user_profile';
  static const String projects = '/projects';
  static const String settings = '/settings';
  static const String editTask = '/edit_task';
  static const String editSubTask = '/edit_sub_task';
  static const String addSubTask = '/add_sub_task';
  static const String processDetail = '/process_detail';

  static final routes = [
    // GetPage(
    //     name: homePage,
    //     page: () => const HomePage(),
    //     binding: BindingsBuilder(() {
    //       Get.put<HomePageController>(
    //         HomePageController(),
    //       );
    //     })),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: homePage, page: () => const HomePage()),
    GetPage(name: projects, page: () => const Projects()),
    GetPage(name: settings, page: () => const Settings()),
    GetPage(name: updateUserProfile, page: () => const UpdateUserProfile()),
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
              status: Get.arguments["object"],
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
