import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CollectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RaisedButton(
          onPressed: () {
            StoreProvider.of<AppState>(context)
                .dispatch(OpenCollectionAction(collectionId: "c1"));
          },
          child: Text("Collection c1"),
        ),
      ],
    );
  }
}
