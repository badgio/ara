import 'package:ara/redux/app_state.dart';
import 'package:ara/routes.dart';
import 'package:ara/views/common/bottom_bar.dart';
import 'package:ara/views/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MainScreen extends StatefulWidget {
  final Map<String, GlobalKey<NavigatorState>> navigatorKeys;
  MainScreen({this.navigatorKeys});

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
        return WillPopScope(
          onWillPop: () async {
            // This is for avoiding the back button to close the app
            // This will pop the subnavigations, and if in the "root", will
            // stay in the same place
            final isFirstRouteInTab = await widget
                .navigatorKeys[Routes.getTabRouteByIndex(vm.barSelectedIndex)]
                .currentState
                .maybePop();
            if (isFirstRouteInTab) {
              return false;
            }
            return isFirstRouteInTab;
          },
          child: Scaffold(
            appBar: CommonAppBar(
              title: _getTitle(vm),
            ),
            body: _getBody(vm),
            bottomNavigationBar: BottomBar(),
          ),
        );
      },
    );
  }

  Widget _getBody(_MainScreenViewModel vm) {
    List<Widget> pageList = List<Widget>();
    pageList.add(
      Navigator(
        key: widget.navigatorKeys[Routes.home],
        initialRoute: Routes.home,
        onGenerateRoute: Routes.generateMainScreenRoute,
      ),
    );
    pageList.add(
      Navigator(
        key: widget.navigatorKeys[Routes.search],
        initialRoute: Routes.search,
        onGenerateRoute: Routes.generateMainScreenRoute,
      ),
    );
    pageList.add(
      Navigator(
        key: widget.navigatorKeys[Routes.collections],
        initialRoute: Routes.collections,
        onGenerateRoute: Routes.generateMainScreenRoute,
      ),
    );
    pageList.add(
      Navigator(
        key: widget.navigatorKeys[Routes.you],
        initialRoute: Routes.you,
        onGenerateRoute: Routes.generateMainScreenRoute,
      ),
    );
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
