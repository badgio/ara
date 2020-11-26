import 'package:flutter/material.dart';

class AriaTheme {
  ThemeData get theme => ThemeData(
        primaryColor: Colors.red,
        backgroundColor: Colors.white,
        bottomNavigationBarTheme: bottomBarTheme,
        textTheme: textTheme,
        dividerColor: Colors.black,
      );

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

  TextTheme textTheme = TextTheme(
    headline4: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
    headline5: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    headline6: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );
}
