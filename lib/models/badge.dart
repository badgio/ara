class Badge implements Comparable {
  String id;
  String name;
  String image;
  String description;

  Badge({
    this.id,
    this.name,
    this.image,
    this.description,
  });

  @override
  int compareTo(dynamic b) {
    if (b is Badge)
      return b.name.compareTo(this.name);
    else
      return 0;
  }
}
