import 'dart:collection';
import 'package:ara/models/collection.dart';
import 'package:ara/models/badge.dart';

class CollectionRepository {
  // BackendDAO
  Set<Collection> _collections;
  Set<Badge> _badges;
  Set<Collection> _timeLimited;

  CollectionRepository() {
    _collections = SplayTreeSet();
    _badges = SplayTreeSet();
    _timeLimited = SplayTreeSet();
  }

  Future<Collection> getCollection(String id) async {
    return Future(() => _collections.singleWhere((c) => c.id == id));
  }

  Future<Set<Collection>> getAllCollections() async {
    return Future(() => _collections);
  }

  Future<Badge> getBadge(String id) async {
    return await Future(() => _badges.singleWhere((b) => b.id == id));
  }

  Future<Set<Badge>> getAllBadges() async {
    return Future(() => _badges);
  }

  Future<Set<Collection>> getTimeLimited() async {
    return await Future(() => _timeLimited);
  }

  void addBadge(Badge badge) {
    _badges.add(badge);
  }

  void updateBadge(Badge badge) {
    this._badges.removeWhere((b) => b.id == badge.id);
    this._badges.add(badge);
  }

  void addCollections(Set<Collection> collections) {
    _collections.addAll(collections);
  }

  void addBadges(Set<Badge> badges) {
    _badges.addAll(badges);
  }

  void addTimeLimited(Set<Collection> timeLimited) {
    _timeLimited.addAll(timeLimited);
  }

  void updateCollection(Collection collection) {
    this._collections.removeWhere((c) => c.id == collection.id);
    this._collections.add(collection);
  }
}
