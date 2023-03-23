import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_manager/app_utils/app_routes.dart';
import 'package:task_manager/app_utils/shared_prefs/shared_prefs.dart';
import 'app_utils/ios_permission.dart';
import 'app_utils/local_string.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool? status = true;
  status = SharedPrefs.getBool(SharedPrefs.theme);
  requestIOSPermissions(FlutterLocalNotificationsPlugin());
  await Permission.camera.request();
  await Permission.photos.request();
  runApp(GetMaterialApp(
    getPages: AppRouteName.routes,
    initialRoute: AppRouteName.splash,
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
      ),));
}