import 'dart:convert';

import 'package:ara/models/badge.dart';
import 'package:ara/models/collection.dart';
import 'package:ara/models/location.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/views/search/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:redux/redux.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Map(),
        _SearchBar(),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SearchViewModel>(
      builder: (context, vm) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: DataSearch(badges: vm.badges));
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 0.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Filter here..."),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.search,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      converter: _SearchViewModel.fromStore,
      distinct: true,
    );
  }
}

class DataSearch extends SearchDelegate<String>{

  Set<Badge> badges;

  DataSearch({this.badges});

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for clear text button
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //show result on the map based on the selection TODO
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final badgeNameArr = [];
    final badgeImageArr = [];
    final badgeIDArr = [];
    final it = badges.iterator;

    while(it.moveNext()) {
      badgeNameArr.add(it.current.name.toString());
      badgeImageArr.add(it.current.image);
      badgeIDArr.add(it.current.id);
    }

    //show when someone searches for something
    final suggestionList = query.isEmpty
        ? badgeNameArr
        : badgeNameArr.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          StoreProvider.of<AppState>(context)
              .dispatch(OpenBadgeAction(badgeId: badgeIDArr[index]));
        },
        leading: CircleAvatar(
            backgroundImage: MemoryImage(base64Decode(badgeImageArr[index])),
            radius: 20,
        ),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0,query.length),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(
                    color: Colors.grey,
                ),
              ),
            ]
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}

class _SearchViewModel {
  final Set<Badge> badges;

  static _SearchViewModel fromStore(Store<AppState> store) {
    return _SearchViewModel(
      badges: store.state.selectedBadges,
    );
  }

  _SearchViewModel({this.badges});
}

class _Map extends StatefulWidget {
  _Map({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<_Map> {
  double currentZoom;
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    currentZoom = 13.0;
  }

  @override
  Widget build(BuildContext context) {
    bool _building = true; // this is necessary to avoid setState during build

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _building = false;
    });

    return StoreConnector<AppState, _SearchViewModel>(
      builder: (context, vm) {
        List<Marker> markers = [];
        vm.badges.forEach((b) {
          markers.add(LocationMarker(
            size: _getMarkerSizeFromZoom(currentZoom),
            location: Location(
              lat: b.lat,
              lon: b.lng,
              name: b.name,
              collections: b.collections.toList(),
            ),
            completed: b.redeemed,
          ));
        });
        return FlutterMap(
          options: MapOptions(
            center: LatLng(41.542503, -8.417631),
            zoom: currentZoom,
            maxZoom: 18,
            onPositionChanged: (pos, ges) {
              if (!_building) updateZoom(pos, ges);
            },
            plugins: [
              PopupMarkerPlugin(),
            ],
            interactive: true,
            onTap: (_) => _popupLayerController.hidePopup(),
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            PopupMarkerLayerOptions(
              markers: markers,
              popupController: _popupLayerController,
              popupBuilder: (_, Marker marker) {
                if (marker is LocationMarker)
                  return LocationMarkerPopup(
                    location: marker.location,
                    onClose: () {
                      _popupLayerController.hidePopup();
                    },
                  );
                return Card(
                  child: Text("Oops"),
                );
              },
            ),
          ],
        );
      },
      converter: _SearchViewModel.fromStore,
      distinct: true,
    );
  }

  double _getMarkerSizeFromZoom(double curZoom) {
    if (curZoom < 13)
      return 10;
    else {
      if (curZoom < 14)
        return 20;
      else {
        if (curZoom < 16)
          return 30;
        else {
          return 40;
        }
      }
    }
  }

  void updateZoom(MapPosition pos, bool hasGesture) {
    setState(() {
      currentZoom = pos.zoom;
    });
  }
}
