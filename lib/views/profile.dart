import 'package:ara/models/badge.dart';
import 'package:ara/models/collection.dart';
import 'package:ara/models/info_user.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/views/common/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ProfileViewModel>(
      builder: (context, vm) {
        List<Widget> previews = [];
        vm.collections.forEach((col) {
          previews.add(CollectionPreviewProfile(
              id: col.id, title: col.name, badges: col.badges.toList()));
        });
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
                            _buildMyInfo(context, vm.user.name, vm.user.city, vm.user.country),
                            //_buildMyInfo(context, vm.user.name, vm.user.city, vm.user.country),
                            _buildMetrics(context, vm.badges, vm.collections),
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
                          Center(
                            child: Text(
                              "Soon",
                              style: Theme.of(context).textTheme.headline5,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        );
        return ListView.builder(
          itemCount: previews.length,
          itemBuilder: (BuildContext context, int index) {
            return previews[index];
          },
        );
      },
      converter: _ProfileViewModel.fromStore,
      distinct: true,
    );
  }

  Widget _buildMyInfo(BuildContext context, String name, String city, String country) {
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
            name,
            style: Theme.of(context).textTheme.headline5,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Text(
            city + ', ' + country,
            style: Theme.of(context).textTheme.bodyText2,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, Set<Badge> badges, Set<Collection> collections) {
    int redeemedBadges = 0;
    int completedCollections = 0;

    final b = badges.iterator;

    while(b.moveNext()) {
      if(b.current.redeemed) redeemedBadges = redeemedBadges + 1;
    }

    final col = collections.iterator;

    while(col.moveNext()) {
      var it = col.current.badges.iterator;
      var completed = true;

      while(it.moveNext()) {
        if(!it.current.redeemed) {
          completed = false;
          break;
        }
      }

      if(completed) completedCollections = completedCollections + 1;
    }

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
            completedCollections.toString(),
            style: Theme.of(context).textTheme.bodyText2,
            softWrap: true,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Badges Redeemed",
              style: Theme.of(context).textTheme.headline5,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            redeemedBadges.toString(),
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

class _ProfileViewModel {
  final Set<Collection> collections;
  final Set<Badge> badges;
  InfoUser user;

  _ProfileViewModel({this.collections, this.badges, this.user});

  static _ProfileViewModel fromStore(Store<AppState> store) {
    return _ProfileViewModel(
      collections: store.state.selectedCollections,
      badges: store.state.selectedBadges,
      user: store.state.selectedUser,
    );
  }
}
