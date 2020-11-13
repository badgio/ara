import 'package:ara/redux/app_state.dart';
import 'package:ara/views/bottom_bar.dart';
import 'package:ara/views/collections.dart';
import 'package:ara/views/common/app_bar.dart';
import 'package:ara/views/home.dart';
import 'package:ara/views/profile.dart';
import 'package:ara/views/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _MainScreenViewModel>(
      converter: _MainScreenViewModel.fromStore,
      distinct: true,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            title: _getTitle(vm),
          ),
          body: _getBody(vm),
          bottomNavigationBar: BottomBar(),
        );
      },
    );
  }

  Widget _getBody(_MainScreenViewModel vm) {
    List<Widget> pageList = List<Widget>();
    pageList.add(HomePage());
    pageList.add(SearchPage());
    pageList.add(CollectionsPage());
    pageList.add(ProfilePage());
    return IndexedStack(
      index: vm.barSelectedIndex,
      children: pageList,
    );
  }

  String _getTitle(_MainScreenViewModel vm) {
    switch (vm.barSelectedIndex) {
      case 0:
        return "Homepage";
      case 1:
        return "Search";
      case 2:
        return "Collections";
      case 3:
        return "Profile";
    }
    return "Oops";
  }
}

class _MainScreenViewModel {
  final int barSelectedIndex;

  _MainScreenViewModel({this.barSelectedIndex = 0});

  static _MainScreenViewModel fromStore(Store<AppState> store) {
    return _MainScreenViewModel(barSelectedIndex: store.state.navSelectedIndex);
  }
}
