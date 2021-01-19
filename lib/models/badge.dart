class Badge implements Comparable {
  String id;
  String name;
  String image;
  String description;
  bool redeemed;
  Set<String> collections;

  Badge({
    this.id,
    this.name,
    this.image,
    this.description,
    this.redeemed,
    this.collections,
  });

  @override
  int compareTo(dynamic b) {
    if (b is Badge)
      return b.name.compareTo(this.name);
    else
      return 0;
  }
}
