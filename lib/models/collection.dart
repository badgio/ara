import 'dart:collection';

import 'package:ara/models/badge.dart';

class Collection implements Comparable {
  String id;
  String name;
  String imageUrl;
  String image; // base64 image
  String description;
  Set<Badge> badges;
  DateTime startDate;
  DateTime endDate;

  Collection({
    this.id,
    this.name,
    this.imageUrl,
    this.image,
    this.description,
    this.badges,
    this.startDate,
    this.endDate,
  });

  @override
  String toString() {
    return "Collection{id: $id, name: $name, description: $description}";
  }

  @override
  int compareTo(dynamic c) {
    if (c is Collection)
      return c.name.compareTo(this.name);
    else
      return 0;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["startDate"] = startDate.toIso8601String();
    map["endDate"] = endDate != null ? endDate.toIso8601String() : null;
    map["image"] = image;
    return map;
  }

  static Collection fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      startDate: DateTime.parse(map["startDate"]),
      endDate: map["endDate"] != null ? DateTime.parse(map["endDate"]) : null,
      image: map["image"],
    );
  }

  void addBadge(Badge b) {
    if (badges == null) {
      badges = SplayTreeSet();
    }
    badges.add(b);
  }
}
