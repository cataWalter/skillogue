class Event {
  String name;
  String country;
  String city;
  DateTime? eventDate;
  List<String> skills = [];

  Event( this.name, this.country, this.city, this.eventDate,
      this.skills);
}
