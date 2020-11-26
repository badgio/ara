import 'package:ara/models/location.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong/latlong.dart';

class LocationMarker extends Marker {
  final bool completed;
  final double size;
  final Location location;

  LocationMarker({
    this.completed = false,
    this.size = 20,
    this.location,
  }) : super(
          point: LatLng(location.lat, location.lon),
          height: size,
          width: size,
          builder: (ctx) => Container(
            child: Icon(
              completed ? Icons.wrong_location : Icons.add_location_alt,
              color: completed ? Colors.red[600] : Colors.green[700],
              size: size,
            ),
          ),
          anchorPos: AnchorPos.align(AnchorAlign.center),
        );
}

class LocationMarkerPopup extends StatelessWidget {
  const LocationMarkerPopup({this.location, this.onClose});

  final Location location;
  final GestureTapCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5,
        left: 5,
        right: 5,
      ),
      child: Stack(
        children: [
          GestureDetector(
            child: Container(
              child: Icon(Icons.close),
              alignment: Alignment.topLeft,
            ),
            onTap: onClose,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Text(
              location.name,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<Widget> collections = List();
    location.collections.forEach((c) {
      collections.add(
        GestureDetector(
          child: CircleAvatar(
            backgroundImage: NetworkImage(c.imageUrl),
          ),
          onTap: () => StoreProvider.of<AppState>(context)
              .dispatch(OpenCollectionAction(collectionId: "c1")),
        ),
      );
    });

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
        top: 2,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: collections,
      ),
    );
  }
}
