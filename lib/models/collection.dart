import 'package:ara/models/badge.dart';

class Collection implements Comparable {
  String id;
  String name;
  String imageUrl;
  String description;
  Set<Badge> badges;
  DateTime startDate;
  DateTime endDate;

  Collection({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.badges,
    this.startDate,
    this.endDate,
  });

  @override
  String toString() {
    return "Collection{id: $id, name: $name, descrption: $description}";
  }

  @override
  int compareTo(dynamic c) {
    if (c is Collection)
      return c.name.compareTo(this.name);
    else
      return 0;
  }
}
