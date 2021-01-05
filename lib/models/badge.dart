class Badge implements Comparable {
  String id;
  String name;
  String imageUrl;
  String description;
  String image; //base64 image

  Badge({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.image,
  });

  @override
  int compareTo(dynamic b) {
    if (b is Badge)
      return b.name.compareTo(this.name);
    else
      return 0;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["image"] = image;
    return map;
  }

  static Badge fromMap(Map<String, dynamic> map) {
    return Badge(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      image: map["image"],
    );
  }
}
