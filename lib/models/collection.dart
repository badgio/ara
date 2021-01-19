import 'package:ara/models/badge.dart';

class Collection implements Comparable {
  String id;
  String name;
  String image;
  String description;
  Set<Badge> badges;
  DateTime startDate;
  DateTime endDate;
  double status;
  List<String> redeemedBadges;
  String reward;

  Collection({
    this.id,
    this.name,
    this.image,
    this.description,
    this.badges,
    this.startDate,
    this.endDate,
    this.status = 0,
    this.redeemedBadges,
    this.reward,
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

  void addRedeemedBadge(String id) {
    this.redeemedBadges.add(id);
  }

  bool isRedeemed(String uuid) {
    return redeemedBadges.contains(uuid);
  }

  void updateBadges(Badge badge) {
    this.badges.removeWhere((b) => b.id == badge.id);
    this.badges.add(badge);
  }
}
