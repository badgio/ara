import 'dart:collection';
import 'package:ara/models/collection.dart';
import 'package:ara/models/badge.dart';

class CollectionRepository {
  // BackendDAO
  Set<Collection> _collections;
  Set<Badge> _badges;

  CollectionRepository() {
    _collections = SplayTreeSet();
    _badges = SplayTreeSet();
    Badge b1 = Badge(
      id: "b1",
      name: "Tasca do Miguel",
      image: "https://bit.ly/33TaWHw",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b1);
    Badge b2 = Badge(
      id: "b2",
      name: "Rodízio do Diogo",
      image: "https://bit.ly/37KiWf5",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b2);
    Badge b3 = Badge(
      id: "b3",
      name: "Cupcakes da Rafaela",
      image: "https://bit.ly/2JKBeoy",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b3);
    Badge b4 = Badge(
      id: "b4",
      name: "Panados do Luís",
      image: "https://bit.ly/2VSdIIQ",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b4);
    Badge b5 = Badge(
      id: "b5",
      name: "Ponchas do Francisco",
      image: "https://bit.ly/39QgmGW",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b5);
    Badge b6 = Badge(
      id: "b6",
      name: "Coxinhas do André",
      image: "https://bit.ly/2W4SbNb",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b6);
    Badge b7 = Badge(
      id: "b7",
      name: "Franguinho à José",
      image: "https://bit.ly/3lUdATx",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b7);
    Set<Badge> s1 = SplayTreeSet<Badge>();
    s1.add(b1);
    s1.add(b2);
    s1.add(b3);
    s1.add(b4);
    Set<Badge> s2 = SplayTreeSet<Badge>();
    s2.add(b4);
    s2.add(b5);
    s2.add(b6);
    s2.add(b7);
    Collection c1 = Collection(
      id: "c1",
      name: "Badgio Cool 2021",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
      badges: s1,
    );
    _collections.add(c1);
    Collection c2 = Collection(
      id: "c2",
      name: "Collection B",
      description:
          "Lorem ipsum dolor sit consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
      badges: s2,
    );
    _collections.add(c2);
    Collection c3 = Collection(
      id: "c3",
      name: "Collection C",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
      badges: s1,
    );
    _collections.add(c3);
    Collection c4 = Collection(
      id: "c4",
      name: "Collection D",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
      badges: s2,
    );
    _collections.add(c4);
    Collection c5 = Collection(
      id: "c5",
      name: "Collection E",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
      badges: s1,
    );
    _collections.add(c5);
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
    return await Future(() => _badges);
  }

  void addBadge(Badge badge) {
    _badges.add(badge);
  }
}
