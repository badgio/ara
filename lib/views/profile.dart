import 'package:ara/models/badge.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CollectionsPageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Badge> badges = List();
    badges.add(Badge(
      id: "b1",
      name: "Tasca do Miguel",
      image: "https://bit.ly/33TaWHw",
    ));
    badges.add(Badge(
      id: "b2",
      name: "Rodízio do Diogo",
      image: "https://bit.ly/37KiWf5",
    ));
    badges.add(Badge(
      id: "b3",
      name: "Cupcakes da Rafaela",
      image: "https://bit.ly/2JKBeoy",
    ));
    badges.add(Badge(
      id: "b4",
      name: "Panados do Luís",
      image: "https://bit.ly/2VSdIIQ",
    ));
    List<Badge> badges2 = List();
    badges2.add(Badge(
      id: "b4",
      name: "Panados do Luís",
      image: "https://bit.ly/2VSdIIQ",
    ));
    badges2.add(Badge(
      id: "b5",
      name: "Ponchas do Francisco",
      image: "https://bit.ly/39QgmGW",
    ));
    badges2.add(Badge(
      id: "b6",
      name: "Coxinhas do André",
      image: "https://bit.ly/2W4SbNb",
    ));
    badges2.add(Badge(
      id: "b7",
      name: "Franguinho à José",
      image: "https://bit.ly/3lUdATx",
    ));
    List<Widget> previews = [
      CollectionPreviewProfile(
        id: "c1",
        title: "Badgio Cool 2021",
        badges: badges,
      ),
      CollectionPreviewProfile(
        id: "c2",
        title: "Collection B",
        badges: badges2,
      ),
      CollectionPreviewProfile(
        id: "c3",
        title: "Collection C",
        badges: badges,
      ),
      CollectionPreviewProfile(
        id: "c4",
        title: "Collection D",
        badges: badges,
      ),
      CollectionPreviewProfile(
        id: "c5",
        title: "Collection E",
        badges: badges,
      ),
    ];
    List<Widget> friendPreviews = [
      FriendPreviewProfile(
        id: "f1",
        name: "Miguel Carvalho",
        city: "Braga",
        country: "Portugal",
        nrBadges: 40,
        nrCollections: 4,
        nrRewards: 4,
      ),
      FriendPreviewProfile(
        id: "f2",
        name: "Luís Alves",
        city: "Braga",
        country: "Portugal",
        nrBadges: 80,
        nrCollections: 7,
        nrRewards: 9,
      ),
      FriendPreviewProfile(
        id: "f3",
        name: "Rafaela Rodrigues",
        city: "Braga",
        country: "Portugal",
        nrBadges: 60,
        nrCollections: 3,
        nrRewards: 6,
      ),
      FriendPreviewProfile(
        id: "f4",
        name: "Francisco Reinolds",
        city: "Funchal",
        country: "Portugal",
        nrBadges: 30,
        nrCollections: 1,
        nrRewards: 3,
      ),
    ];
    return Padding(
        padding: EdgeInsets.only(),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SafeArea(
                    child: Row(
                      children: [
                        _buildMyInfo(context),
                        _buildMetrics(context),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TabBar(
                    tabs: [
                      Tab(
                          child: Text('Collections',
                              style: TextStyle(color: Colors.black))),
                      Tab(
                          child: Text('Friends',
                              style: TextStyle(color: Colors.black))),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: previews.length,
                        itemBuilder: (BuildContext context, int index) {
                          return previews[index];
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: friendPreviews.length,
                        itemBuilder: (BuildContext context, int index) {
                          return friendPreviews[index];
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildMyInfo(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 10,
              top: 10,
            ),
          ),
          CircleAvatar(
            radius: 50,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 100,
              top: 10,
            ),
          ),
          Text(
            "My Awesome Name that never fuckin ends",
            style: Theme.of(context).textTheme.headline5,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Text(
            "City, Country",
            style: Theme.of(context).textTheme.bodyText2,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Completed Collections",
              style: Theme.of(context).textTheme.headline5,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "X",
            style: Theme.of(context).textTheme.bodyText2,
            softWrap: true,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Total Rewards",
              style: Theme.of(context).textTheme.headline5,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "X",
            style: Theme.of(context).textTheme.bodyText2,
            softWrap: true,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Badges",
              style: Theme.of(context).textTheme.headline5,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "X",
            style: Theme.of(context).textTheme.bodyText2,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

class CollectionPreviewProfile extends StatelessWidget {
  final String id;
  final String title;
  final List<Badge> badges;

  CollectionPreviewProfile({this.id, this.title, this.badges});

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
        style: Theme.of(context).textTheme.headline6,
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
              backgroundImage: NetworkImage(b.image),
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

class FriendPreviewProfile extends StatelessWidget {
  final String id;
  final String name;
  final String city;
  final String country;
  final int nrBadges;
  final int nrCollections;
  final int nrRewards;

  FriendPreviewProfile(
      {this.id,
      this.name,
      this.city,
      this.country,
      this.nrBadges,
      this.nrCollections,
      this.nrRewards});

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
          Row(children: [
            CircleAvatar(
              radius: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 10,
              ),
            ),
            _buildName(context),
            Text(
              nrCollections.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 60,
              ),
            ),
            Text(
              nrBadges.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 10,
              ),
            ),
          ]),
          Padding(
            padding: EdgeInsets.only(
              bottom: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Expanded(
      child: Text(
        name,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
