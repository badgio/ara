import 'package:ara/models/badge.dart';
import 'package:ara/models/collection.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/views/common/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CollectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _CollectionsViewModel>(
      builder: (context, vm) {
        List<Widget> previews = [];
        vm.collections.forEach((col) {
          previews.add(CollectionPreview(
              id: col.id, title: col.name, badges: col.badges.toList()));
        });
        return ListView.builder(
          itemCount: previews.length,
          itemBuilder: (BuildContext context, int index) {
            return previews[index];
          },
        );
      },
      converter: _CollectionsViewModel.fromStore,
      distinct: true,
    );
  }
}

class CollectionPreview extends StatelessWidget {
  final String id;
  final String title;
  final List<Badge> badges;

  CollectionPreview({this.id, this.title, this.badges});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildTitle(context),
              _buildSeeMore(context),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: _buildBadgePreview(context),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              endIndent: 40,
            ),
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

  Widget _buildSeeMore(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        StoreProvider.of<AppState>(context)
            .dispatch(OpenCollectionAction(collectionId: id));
      },
      child: Text("See All"),
    );
  }

  List<Widget> _buildBadgePreview(BuildContext context) {
    List<Widget> previewList = List();
    for (int i = 0; i < 3 && i < badges.length; i++) {
      previewList.add(_buildBadge(context, badges[i]));
    }
    return previewList;
  }

  Widget _buildBadge(BuildContext context, Badge b) {
    return Expanded(
      flex: 4,
      child: FlatButton(
        onPressed: () {
          StoreProvider.of<AppState>(context)
              .dispatch(OpenBadgeAction(badgeId: b.id));
        },
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: [
            GreyImage(
              badge: b,
              radius: 36,
              key: key,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                b.name,
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionsViewModel {
  final Set<Collection> collections;
  //MobileUser user;

  _CollectionsViewModel({this.collections});

  static _CollectionsViewModel fromStore(Store<AppState> store) {
    return _CollectionsViewModel(
      collections: store.state.selectedCollections,
    );
  }
}
