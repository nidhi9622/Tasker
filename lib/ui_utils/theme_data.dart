import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.black54,
    scaffoldBackgroundColor: const Color(0xffededed),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  );
}

ThemeData darkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    primaryColorDark: Colors.white,
    primaryColorLight: Colors.white70,
    scaffoldBackgroundColor: const Color(0xff363535),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  );
}
