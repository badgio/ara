import 'package:flutter/material.dart';

class AriaTheme {
  ThemeData get theme => ThemeData(
      primaryColor: Colors.red,
      buttonTheme: ButtonThemeData(),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              primary: Colors.red, backgroundColor: Colors.white)));
}
