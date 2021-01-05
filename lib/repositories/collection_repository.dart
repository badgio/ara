import 'dart:collection';
import 'package:ara/models/collection.dart';
import 'package:ara/models/badge.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CollectionRepository {
  // BackendDAO
  Set<Collection> _collections;
  Set<Badge> _badges;
  final Future<Database> _db = getDatabasesPath().then(
    (path) {
      Future<Database> db = openDatabase(
        join(path, "collections_database.db"),
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE collections(id TEXT PRIMARY KEY, name TEXT, description TEXT, startDate TEXT, endDate TEXT, image BLOB)",
          );
          db.execute(
            "CREATE TABLE badges(id TEXT PRIMARY KEY, name TEXT, description TEXT, image BLOB)",
          );
          db.execute(
            "CREATE TABLE collections_badges(id INTEGER PRIMARY KEY, badge_id TEXT, collection_id TEXT, FOREIGN KEY(badge_id) REFERENCES badges(id), FOREIGN KEY(collection_id) REFERENCES collections(id))",
          );
        },
        version: 4,
        onConfigure: (db) {
          db.execute(
            "PRAGMA foreign_keys = ON",
          );
        },
      );
      print("Database opened!");
      return db;
    },
  );

  CollectionRepository() {
    _collections = SplayTreeSet();
    _badges = SplayTreeSet();
    Badge b1 = Badge(
      id: "b1",
      name: "Tasca do Miguel",
      imageUrl: "https://bit.ly/33TaWHw",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b1);
    Badge b2 = Badge(
      id: "b2",
      name: "Rodízio do Diogo",
      imageUrl: "https://bit.ly/37KiWf5",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b2);
    Badge b3 = Badge(
      id: "b3",
      name: "Cupcakes da Rafaela",
      imageUrl: "https://bit.ly/2JKBeoy",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b3);
    Badge b4 = Badge(
      id: "b4",
      name: "Panados do Luís",
      imageUrl: "https://bit.ly/2VSdIIQ",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b4);
    Badge b5 = Badge(
      id: "b5",
      name: "Ponchas do Francisco",
      imageUrl: "https://bit.ly/39QgmGW",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b5);
    Badge b6 = Badge(
      id: "b6",
      name: "Coxinhas do André",
      imageUrl: "https://bit.ly/2W4SbNb",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi fringilla purus ut tortor pharetra blandit. Pellentesque vitae lorem vestibulum, maximus ex a, blandit mauris.",
    );
    _badges.add(b6);
    Badge b7 = Badge(
      id: "b7",
      name: "Franguinho à José",
      imageUrl: "https://bit.ly/3lUdATx",
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
    _collections.map((e) => saveCollection(e));
    print("Collections loaded");
  }

  Future<Collection> getCollection(String id) async {
    Database db = await _db;
    List<Map> collections = await db.query(
      "collections",
      where: "id = ?",
      whereArgs: [id],
    );
    if (collections.length > 0) {
      Collection c = Collection.fromMap(collections.first);
      List<Map> badges = await db.rawQuery(
          "SELECT b.id, b.name, b.description, b.image FROM badges b INNER JOIN collections_badges c on b.id = c.badge_id WHERE c.collection_id = ? ",
          [c.id]);
      badges.map((b) {
        Badge badge = Badge.fromMap(b);
        c.addBadge(badge);
      });
      return Future(() => c);
    }
    return null;
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

  // Stores a given badge to a given collection
  Future<void> saveBadge(Badge b, Collection c) async {
    Database db = await _db;
    List<Map> collections = await db.query(
      "collections",
      where: "id = ?",
      whereArgs: [c.id],
    );
    // if no collection with that id, abort
    if (collections.length < 0) {
      return;
    }

    await db.transaction((tx) async {
      await tx.insert(
        "badges",
        b.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await tx.rawInsert(
        'REPLACE INTO collections_badges(badge_id, collection_id) VALUES(?, ?)',
        [b.id, c.id],
      );
    });
  }

  Future<void> saveCollection(Collection c) async {
    Database db = await _db;
    await db.transaction((tx) async {
      int inserted = await tx.insert(
        "collections",
        c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("Inserted $inserted");
      if (c.badges != null) {
        c.badges.map((b) => saveBadge(b, c));
      }
    });
  }
}
