import 'dart:convert';
import 'package:ara/models/badge.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:ara/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BadgeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _BadgeViewModel>(
      builder: (context, vm) {
        return Column(children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
          ),
          Text(
            vm.b.name ?? '',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            child: CircleAvatar(
              backgroundImage: MemoryImage(base64Decode(vm.b.image)) ?? '',
              radius: 100,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
            child: Text(vm.b.description ?? ''),
          ),
        ]);
      },
      converter: _BadgeViewModel.fromStore,
      distinct: true,
    );
  }
}

class _BadgeViewModel {
  MobileUser user;
  Badge b;

  static _BadgeViewModel fromStore(Store<AppState> store) {
    return _BadgeViewModel(
      b: store.state.selectedBadge,
      user: store.state.user,
    );
  }

  _BadgeViewModel({this.b, this.user});
}
