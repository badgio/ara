import 'dart:convert';
import 'dart:collection';
import 'package:ara/models/badge.dart';
import 'package:ara/models/collection.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/views/common/image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CollectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _CollectionViewModel>(
      builder: (context, vm) {
        return ListView(
          children: [
            _buildHeader(
                context, vm.col.image, vm.col.name, vm.col.description),
            Divider(
              thickness: 1.8,
              color: Theme.of(context).dividerColor,
              indent: 60,
              endIndent: 60,
            ),
            _buildBadgeList(
                vm.col.redeemedBadges.length, vm.col.badges, context),
          ],
        );
      },
      converter: _CollectionViewModel.fromStore,
      distinct: true,
    );
  }

  Widget _buildBadgeList(
      int redeemed, Set<Badge> badges, BuildContext context) {
    return Column(
      children: [
        _InfoBar(
          redeemed: redeemed,
          total: badges.length,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20, top: 10, left: 10, right: 10),
          child: _buildBadgeGrid(badges, context),
        ),
      ],
    );
  }

  Widget _buildBadgeGrid(Set<Badge> badges, BuildContext context) {
    List<ConstrainedBox> avatars = List();
    SplayTreeSet<Badge> sortedBadges = SplayTreeSet.from(badges, (a, b) {
      if (a.redeemed && b.redeemed || !a.redeemed && !b.redeemed) {
        return a.name.compareTo(b.name);
      } else if (a.redeemed) {
        return -1;
      } else {
        return 1;
      }
    });
    for (Badge badge in sortedBadges) {
      avatars.add(
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            width: 80,
          ),
          child: FlatButton(
            onPressed: () {
              StoreProvider.of<AppState>(context)
                  .dispatch(OpenBadgeAction(badgeId: badge.id));
            },
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: [
                GreyImage(
                  badge: badge,
                  key: key,
                  radius: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    badge.name,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Wrap(
      spacing: 20,
      runSpacing: 24.0,
      children: avatars,
    );
  }

  Widget _buildHeader(
      BuildContext context, String image, String name, String desc) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(
          top: 20,
          bottom: 10,
        ),
        child: CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey,
          backgroundImage: MemoryImage(base64Decode(image)) ?? '',
        ),
      ),
      Text(
        name,
        style: Theme.of(context).textTheme.headline4,
      ),
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
        child: _Description(text: desc),
      ),
    ]);
  }
}

class _Description extends StatefulWidget {
  final String text;

  _Description({this.text});

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<_Description> {
  static const int SIZE = 150;
  String short;
  bool expanded = false;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > SIZE) {
      short = widget.text.substring(0, SIZE);
    } else {
      short = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        RichText(
          text: TextSpan(
            text: expanded ? widget.text : short,
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: expanded ? "" : "...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  expanded = !expanded;
                });
              },
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}

class _InfoBar extends StatefulWidget {
  final int redeemed;
  final int total;

  _InfoBar({this.redeemed, this.total});

  @override
  _InfoBarState createState() => _InfoBarState();
}

class _InfoBarState extends State<_InfoBar> {
  int _maxBadgeCount;
  int _currentBadgeCount;
  String _filter = "Completed";

  @override
  void initState() {
    this._maxBadgeCount = widget.total;
    this._currentBadgeCount = widget.redeemed;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: RichText(
            text: TextSpan(
                text: "Badges ",
                style: Theme.of(context).textTheme.headline5,
                children: [
                  TextSpan(
                    text: "($_currentBadgeCount/$_maxBadgeCount)",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ]),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: DropdownButton(
                value: _filter,
                elevation: 4,
                items: [
                  DropdownMenuItem(
                    value: "Completed",
                    child: Text("Sort by Completed"),
                  ),
                  DropdownMenuItem(
                    value: "Name",
                    child: Text("Sort by Name"),
                  )
                ],
                onChanged: (newValue) {
                  setState(() {
                    _filter = newValue;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionViewModel {
  final Collection col;
  MobileUser user;

  _CollectionViewModel({this.col, this.user});

  static _CollectionViewModel fromStore(Store<AppState> store) {
    return _CollectionViewModel(
      col: store.state.selectedCollection,
      user: store.state.user,
    );
  }
}
