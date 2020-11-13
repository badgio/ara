import 'package:flutter/material.dart';

class AriaTheme {
  ThemeData get theme => ThemeData(
      primaryColor: Colors.red,
      backgroundColor: Colors.white,
      bottomNavigationBarTheme: bottomBarTheme);

  static const double appBarSize = 52.0;

  static const BottomNavigationBarThemeData bottomBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black,
    type: BottomNavigationBarType.fixed,
    selectedIconTheme: IconThemeData(size: 28),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  );
}
