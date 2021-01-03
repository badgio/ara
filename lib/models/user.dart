class User implements Comparable {
  String id;
  String name;
  String imageUrl;
  String city;
  String country;
  int nrBadges;
  int nrCollections;
  int nrRewards;

  User({
    this.id,
    this.name,
    this.imageUrl,
    this.city,
    this.country,
    this.nrBadges,
    this.nrCollections,
    this.nrRewards,
  });

  @override
  int compareTo(dynamic u) {
    if (u is User)
      return u.id.compareTo(this.id);
    else
      return 0;
  }
}
