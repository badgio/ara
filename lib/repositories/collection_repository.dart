import 'dart:collection';

import 'package:ara/models/collection.dart';
import 'package:ara/models/badge.dart';

class CollectionRepository {
  // BackendDAO
  Set<Collection> _collections;

  CollectionRepository() {
    _collections = SplayTreeSet();
    Badge b1 = Badge(id: "b1", name: "Badge 1");
    Badge b2 = Badge(id: "b2", name: "Badge 2");
    Badge b3 = Badge(id: "b3", name: "Badge 3");
    Badge b4 = Badge(id: "b4", name: "Câmara Municipal de Braga");
    Badge b5 = Badge(id: "b5", name: "Badge 5");
    Badge b6 = Badge(id: "b6", name: "Badge 6");
    Badge b7 = Badge(id: "b7", name: "Badge 7");
    Badge b8 = Badge(id: "b8", name: "Badge 8");
    Badge b9 = Badge(id: "b9", name: "Badge 9");
    Badge b10 = Badge(id: "b10", name: "Badge 10");
    Set<Badge> s1 = SplayTreeSet<Badge>();
    s1.add(b1);
    s1.add(b2);
    s1.add(b3);
    s1.add(b4);
    s1.add(b5);
    s1.add(b6);
    s1.add(b7);
    s1.add(b8);
    s1.add(b9);
    s1.add(b10);
    Collection c1 = Collection(
      id: "c1",
      name: "Collection C1",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris. Proin dapibus neque a rhoncus tristique. Nam vehicula metus ut massa suscipit ullamcorper. Sed vel nisl fermentum, vestibulum urna ac, pretium nulla. Curabitur finibus auctor mi, vel posuere leo volutpat sed. Morbi accumsan pellentesque orci, et semper metus fringilla eget. Phasellus a dictum tellus, et sodales erat. Nullam vitae erat non risus efficitur ultricies a sit amet risus. Cras maximus magna at ligula feugiat volutpat id a lorem.",
      badges: s1,
    );
    _collections.add(c1);
  }

  Future<Collection> getCollection(String id) async {
    return Future(() => _collections.singleWhere((c) => c.id == id));
  }

  Future<Set<Collection>> getAllCollections() async {
    return Future(() => _collections);
  }
}
