import 'package:ara/models/badge.dart';
import 'package:ara/models/collection.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Set<Badge> badges = Set();
    badges.add(Badge(
      id: "b4",
      name: "Tasca do Miguel",
      image: "https://bit.ly/2VSdIIQ",
    ));
    badges.add(Badge(
      id: "b5",
      name: "Ponchas do Francisco",
      image: "https://bit.ly/39QgmGW",
    ));
    badges.add(Badge(
      id: "b6",
      name: "Coxinhas do André",
      image: "https://bit.ly/2W4SbNb",
    ));
    badges.add(Badge(
      id: "b7",
      name: "Franguinho à José",
      image: "https://bit.ly/3lUdATx",
    ));
    badges.add(Badge(
      id: "b8",
      name: "Pizza",
      image: "https://bit.ly/3lUdATx",
    ));

    List<Collection> timeLimited = List();
    timeLimited.add(Collection(
      id: "c1",
      name: "Verde Cool",
      imageUrl: "https://bit.ly/33TaWHw",
      badges: badges,
    ));
    timeLimited.add(Collection(
      id: "c2",
      name: "Tapas de Braga",
      imageUrl: "https://bit.ly/37KiWf5",
      badges: badges,
    ));
    timeLimited.add(Collection(
      id: "c3",
      name: "Rota do Bacalhau",
      imageUrl: "https://bit.ly/2JKBeoy",
      badges: badges,
    ));
    timeLimited.add(Collection(
      id: "c4",
      name: "Rota das Sardinhas",
      imageUrl: "https://bit.ly/2VSdIIQ",
      badges: badges,
    ));

    List<Collection> rewards = List();
    rewards.add(Collection(
      id: "r1",
      name: "Verde Cool 2021",
      imageUrl: "https://bit.ly/33TaWHw",
      badges: badges,
    ));
    rewards.add(Collection(
      id: "r2",
      name: "Igrejas de Braga",
      imageUrl: "https://bit.ly/37KiWf5",
      badges: badges,
    ));
    rewards.add(Collection(
      id: "r3",
      name: "Rota Romana",
      imageUrl: "https://bit.ly/2JKBeoy",
      badges: badges,
    ));

    List<Collection> inProgress = List();
    inProgress.add(Collection(
      id: "p1",
      name: "Igrejas de Mandim",
      imageUrl: "https://bit.ly/33TaWHw",
      badges: badges,
    ));
    inProgress.add(Collection(
      id: "p2",
      name: "Verde Cool 2021",
      imageUrl: "https://bit.ly/37KiWf5",
      badges: badges,
    ));
    inProgress.add(Collection(
      id: "p3",
      name: "Rota do Barroco",
      imageUrl: "https://bit.ly/2JKBeoy",
      badges: badges,
    ));
    inProgress.add(Collection(
      id: "p4",
      name: "Rota do Bacalhau",
      imageUrl: "https://bit.ly/3lUdATx",
      badges: badges,
    ));
    inProgress.add(Collection(
      id: "p5",
      name: "Rota Romana",
      imageUrl: "https://bit.ly/39QgmGW",
      badges: badges,
    ));

    List<Widget> previews = [
      title(),
      CollectionsPreview(
        title: "Time Limited",
        collections: timeLimited,
        percentage: false,
      ),
      CollectionsPreview(
        title: "In Progress",
        collections: inProgress,
        percentage: true,
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
      backgroundImage: NetworkImage(image),
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
                      percent: 0.7,
                      progressColor: Colors.blue,
                      center: image(collection.imageUrl),
                    )
                  : image(collection.imageUrl),
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
