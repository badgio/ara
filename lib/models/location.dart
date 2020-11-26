import 'package:ara/models/collection.dart';

class Location {
  String id;
  String name;
  String description;
  double lon;
  double lat;
  Map<String, String> socialLinks;
  String imageUrl;
  List<Collection> collections;

  Location({
    this.id,
    this.name,
    this.description,
    this.lon,
    this.lat,
    this.socialLinks,
    this.imageUrl,
    this.collections,
  });

  @override
  String toString() {
    return "Location{id: $id, name: $name, description: $description, lat: $lat, lon: $lon}";
  }
}
