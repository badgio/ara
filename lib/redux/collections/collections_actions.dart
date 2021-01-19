import 'package:ara/models/collection.dart';
import 'package:ara/models/badge.dart';

class ImportDataAction {
  const ImportDataAction();

  @override
  String toString() {
    return "ImportDataAction";
  }
}

class LoadCollectionsAction {
  const LoadCollectionsAction();

  @override
  String toString() {
    return "LoadCollectionsAction";
  }
}

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

class CollectionsLoadedAction {
  final Set<Collection> collections;
  final Set<Collection> timeLimited;

  const CollectionsLoadedAction({this.collections, this.timeLimited});

  @override
  String toString() {
    return "CollectionLoadedAction{collection: $collections}";
  }
}

class LoadBadgesAction {
  const LoadBadgesAction();

  @override
  String toString() {
    return "OpenBadgeAction";
  }
}

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
