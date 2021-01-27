import 'dart:ffi';

import 'package:ara/models/collection.dart';

class Badge implements Comparable {
  String id;
  String name;
  String image;
  String description;
  bool redeemed;
  Set<Collection> collections;
  double lat;
  double lng;

  Badge({
    this.id,
    this.name,
    this.image,
    this.description,
    this.redeemed,
    this.collections,
    this.lat,
    this.lng,
  });

  @override
  int compareTo(dynamic b) {
    if (b is Badge)
      return b.name.compareTo(this.name);
    else
      return 0;
  }
}
