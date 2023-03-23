import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_manager/app_utils/app_routes.dart';
import 'package:task_manager/app_utils/shared_prefs/shared_prefs.dart';
import 'package:task_manager/ui_utils/theme_data.dart';
import 'app_utils/ios_permission.dart';
import 'app_utils/local_string.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool? status = true;
  status = SharedPrefs.getBool(SharedPrefs.theme);
  requestIOSPermissions(FlutterLocalNotificationsPlugin());
  // await Permission.camera.request();
  // await Permission.photos.request();
  runApp(GetMaterialApp(
    getPages: AppRouteName.routes,
    initialRoute: AppRouteName.splash,
      themeMode: status == true ? ThemeMode.dark : ThemeMode.light,
      translations: LocalString(),
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(),
      darkTheme: darkThemeData(),));
}