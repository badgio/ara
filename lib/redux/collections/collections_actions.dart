import 'package:ara/models/collection.dart';

class LoadCollectionsAction {}

class OpenCollectionAction {
  final String collectionId;

  const OpenCollectionAction({this.collectionId});

  @override
  String toString() {
    return "OpenCollectionAction{collectionId: $collectionId}";
  }
}

class CollectionLoadedAction {
  final Collection collection;

  const CollectionLoadedAction({this.collection});

  @override
  String toString() {
    return "CollectionLoadedAction{collection: $collection}";
  }
}
