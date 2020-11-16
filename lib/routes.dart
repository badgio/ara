import 'package:ara/views/collections/collection.dart';
import 'package:ara/views/collections/collections_page.dart';
import 'package:ara/views/home.dart';
import 'package:ara/views/profile.dart';
import 'package:ara/views/search.dart';
import 'package:flutter/material.dart';

class Routes {
  static const home = "/home";
  static const signIn = "/signin";
  static const collection = "/collection";
  static const collections = "/collections";
  static const search = "/search";
  static const you = "/you";

  static Route<dynamic> generateMainScreenRoute(RouteSettings settings) {
    switch (settings.name) {
      case collection:
        final page = CollectionView();
        return MaterialPageRoute(builder: (context) => page);
      case home:
        final page = HomePage();
        return MaterialPageRoute(builder: (context) => page);
      case collections:
        final page = CollectionsPage();
        return MaterialPageRoute(builder: (context) => page);
      case search:
        final page = SearchPage();
        return MaterialPageRoute(builder: (context) => page);
      case you:
        final page = ProfilePage();
        return MaterialPageRoute(builder: (context) => page);
      default:
        return null;
    }
  }

  static String getTabRouteByIndex(int index) {
    switch (index) {
      case 0:
        return home;
      case 1:
        return search;
      case 2:
        return collections;
      case 3:
        return you;
      default:
        return home;
    }
  }
}
