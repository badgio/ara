import 'package:ara/models/collection.dart';
import 'package:ara/models/badge.dart';

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

class LoadBadgesAction {}

class OpenBadgeAction {
  final String badgeId;

  const OpenBadgeAction({this.badgeId});

  @override
  String toString() {
    return "OpenBadgeAction{badgeId: $badgeId}";
  }
}

class BadgeLoadedAction {
  final Badge badge;

  const BadgeLoadedAction({this.badge});

  @override
  String toString() {
    return "BadgeLoadedAction{badge: $badge}";
  }
}
