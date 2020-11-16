import 'package:ara/models/badge.dart';
import 'package:ara/models/collection.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:ara/redux/app_state.dart';
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
            _buildHeader(context, vm.col.name, vm.col.description),
            Divider(
              thickness: 1.8,
              color: Theme.of(context).dividerColor,
              indent: 60,
              endIndent: 60,
            ),
            _buildBadgeList(vm.col.badges),
          ],
        );
      },
      converter: _CollectionViewModel.fromStore,
      distinct: true,
    );
  }

  Widget _buildBadgeList(Set<Badge> badges) {
    return Column(
      children: [
        _InfoBar(),
        Padding(
          padding: EdgeInsets.only(bottom: 20, top: 10, left: 10, right: 10),
          child: _buildBadgeGrid(badges),
        ),
      ],
    );
  }

  Widget _buildBadgeGrid(Set<Badge> badges) {
    List<ConstrainedBox> avatars = List();
    for (Badge badge in badges) {
      avatars.add(
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            width: 80,
          ),
          child: Column(
            children: [
              CircleAvatar(
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
      );
    }
    return Wrap(
      spacing: 20,
      runSpacing: 24.0,
      children: avatars,
    );
  }

  Widget _buildHeader(BuildContext context, String name, String desc) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(
          top: 20,
          bottom: 10,
        ),
        child: CircleAvatar(radius: 35),
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
  @override
  _InfoBarState createState() => _InfoBarState();
}

class _InfoBarState extends State<_InfoBar> {
  int _maxBadgeCount = 10;
  int _currentBadgeCount = 2;
  String _filter = "Completed";

  @override
  void initState() {
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
  Collection col;
  MobileUser user;

  _CollectionViewModel({this.col, this.user});

  static _CollectionViewModel fromStore(Store<AppState> store) {
    return _CollectionViewModel(
      col: store.state.selectedCollection,
      user: store.state.user,
    );
  }
}
