import 'package:ara/models/badge.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CollectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Badge> badges = List();
    badges.add(Badge(
      id: "b1",
      name: "Tasca do Miguel",
      imageUrl: "https://bit.ly/33TaWHw",
    ));
    badges.add(Badge(
      id: "b2",
      name: "Rodízio do Diogo",
      imageUrl: "https://bit.ly/37KiWf5",
    ));
    badges.add(Badge(
      id: "b3",
      name: "Cupcakes da Rafaela",
      imageUrl: "https://bit.ly/2JKBeoy",
    ));
    badges.add(Badge(
      id: "b4",
      name: "Panados do Luís",
      imageUrl: "https://bit.ly/2VSdIIQ",
    ));
    List<Badge> badges2 = List();
    badges2.add(Badge(
      id: "b4",
      name: "Panados do Luís",
      imageUrl: "https://bit.ly/2VSdIIQ",
    ));
    badges2.add(Badge(
      id: "b5",
      name: "Ponchas do Francisco",
      imageUrl: "https://bit.ly/39QgmGW",
    ));
    badges2.add(Badge(
      id: "b6",
      name: "Coxinhas do André",
      imageUrl: "https://bit.ly/2W4SbNb",
    ));
    badges2.add(Badge(
      id: "b7",
      name: "Franguinho à José",
      imageUrl: "https://bit.ly/3lUdATx",
    ));
    List<Widget> previews = [
      CollectionPreview(
        id: "c1",
        title: "Badgio Cool 2021",
        badges: badges,
      ),
      CollectionPreview(
        id: "c2",
        title: "Collection B",
        badges: badges2,
      ),
      CollectionPreview(
        id: "c3",
        title: "Collection C",
        badges: badges,
      ),
      CollectionPreview(
        id: "c4",
        title: "Collection D",
        badges: badges2,
      ),
      CollectionPreview(
        id: "c5",
        title: "Collection E",
        badges: badges,
      ),
    ];
    return ListView.builder(
      itemCount: previews.length,
      itemBuilder: (BuildContext context, int index) {
        return previews[index];
      },
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
    for (Badge b in badges) {
      previewList.add(_buildBadge(context, b));
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
              CircleAvatar(
                backgroundImage: NetworkImage(b.imageUrl),
                radius: 36,
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