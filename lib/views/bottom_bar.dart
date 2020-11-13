import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/navigation/navigation_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        label: "Home",
        icon: Icon(Icons.home),
      ),
      BottomNavigationBarItem(
        label: "Search",
        icon: Icon(Icons.search),
      ),
      BottomNavigationBarItem(
          label: "Collections", icon: Icon(Icons.book_outlined)),
      BottomNavigationBarItem(
        label: "You",
        icon: Icon(Icons.person),
      ),
    ];
    return BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      items: items,
    );
  }

  void onTabTapped(int index) {
    StoreProvider.of<AppState>(context)
        .dispatch(BottomBarIndexUpdateAction(newIndex: index));
    setState(() {
      _currentIndex = index;
    });
  }
}
