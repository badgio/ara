class Badge implements Comparable {
  String id;
  String name;

  Badge({this.id, this.name});

  @override
  int compareTo(dynamic b) {
    if (b is Badge)
      return b.name.compareTo(this.name);
    else
      return 0;
  }
}
