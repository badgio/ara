import 'dart:convert';
import 'package:ara/models/collection.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _HomeViewModel>(
      builder: (context, vm) {
        List<Collection> inProgress = [];
        vm.collections.forEach((collection) {
          if (collection.status > 0 && collection.status < 1) {
            inProgress.add(collection);
          }
        });
        List<Widget> previews = [
          title(),
          vm.timeLimited.isNotEmpty
              ? CollectionsPreview(
                  title: "Limited Time",
                  collections: vm.timeLimited.toList(),
                  percentage: false)
              : Container(),
          CollectionsPreview(
              title: "In Progress", collections: inProgress, percentage: true)
        ];
        return ListView.builder(
          itemCount: previews.length,
          itemBuilder: (BuildContext context, int index) {
            return previews[index];
          },
        );
      },
      converter: _HomeViewModel.fromStore,
      distinct: true,
    );
  }
}

Widget divisor() {
  return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Divider(
        indent: 40,
        endIndent: 40,
      ));
}

Widget title() {
  return Wrap(
    alignment: WrapAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 0),
        child: new Text(
          "BADGIO",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
      ),
    ],
  );
}

class CollectionsPreview extends StatelessWidget {
  final String title;
  final List<Collection> collections;
  final bool percentage;

  CollectionsPreview({this.title, this.collections, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          divisor(),
          Row(
            children: [
              _buildTitle(context),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: _buildCollectionGrid(context, percentage),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget image(String image) {
    return CircleAvatar(
      backgroundImage: MemoryImage(base64Decode(image)) ?? '',
      radius: 36,
    );
  }

  Widget _buildCollectionGrid(BuildContext context, bool percentage) {
    List<ConstrainedBox> avatars = List();
    for (Collection collection in collections) {
      avatars.add(ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: 65,
        ),
        child: GestureDetector(
          onTap: () {
            StoreProvider.of<AppState>(context)
                .dispatch(OpenCollectionAction(collectionId: collection.id));
          },
          child: Column(
            children: [
              percentage
                  ? new CircularPercentIndicator(
                      radius: 73.0,
                      lineWidth: 4.0,
                      percent: collection.status,
                      progressColor: Colors.blue,
                      center: image(collection.image),
                    )
                  : image(collection.image),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  collection.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return Wrap(
      spacing: 20,
      runSpacing: 24.0,
      children: avatars,
    );
  }
}

class _HomeViewModel {
  final Set<Collection> collections;
  final Set<Collection> timeLimited;
  //MobileUser user;

  _HomeViewModel({this.collections, this.timeLimited});

  static _HomeViewModel fromStore(Store<AppState> store) {
    return _HomeViewModel(
      collections: store.state.selectedCollections,
      timeLimited: store.state.timeLimited,
    );
  }
}
