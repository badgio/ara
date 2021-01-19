import 'package:ara/models/collection.dart';
import 'package:ara/models/location.dart';
import 'package:ara/views/search/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

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
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      child: GestureDetector(
        onTap: () {
          showSearch(context: context, delegate: DataSearch());
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
  }
}

class DataSearch extends SearchDelegate<String>{

  //hardcoded places
  final places = [
    "Museu dos Biscainhos",
    "Sé de Braga",
    "Igreja dos Terceiros",
    "Igreja dos Congregados",
    "Museu D. Diogo de Sousa",
    "Igreja do Carmo",
    "Restaurante do Padrinho do Zé",
    "Avenida Central",
    "Universidade do Minho",
    "Restaurante 'Cozinha da Sé'"
  ];

  //hardcoded recent places
  final recentPlaces = [
    "Igreja do Carmo",
    "Restaurante do Padrinho do Zé",
    "Avenida Central",
    "Sé de Braga"
  ];

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
    //show when someone searches for something
    final suggestionList = query.isEmpty
        ? recentPlaces
        : places.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.location_city),
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

    List<Collection> collectionList = List();
    collectionList.add(
      Collection(
        name: "Collection A",
        image: "https://bit.ly/3nPTzPm",
      ),
    );
    collectionList.add(
      Collection(
        name: "Collection A",
        image: "https://bit.ly/3nPTzPm",
      ),
    );
    collectionList.add(
      Collection(
        name: "Collection A",
        image: "https://bit.ly/3nPTzPm",
      ),
    );
    collectionList.add(
      Collection(
        name: "Collection A",
        image: "https://bit.ly/3nPTzPm",
      ),
    );
    collectionList.add(
      Collection(
        name: "Collection A",
        image: "https://bit.ly/3nPTzPm",
      ),
    );
    collectionList.add(
      Collection(
        name: "Collection A",
        image: "https://bit.ly/3nPTzPm",
      ),
    );

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
          markers: [
            LocationMarker(
              size: _getMarkerSizeFromZoom(currentZoom),
              location: Location(
                lat: 41.542547,
                lon: -8.417800,
                name: "Local A",
                collections: collectionList,
              ),
              completed: true,
            )
          ],
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
