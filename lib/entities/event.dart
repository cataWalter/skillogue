class Event {
  String objectId;
  String eventName;
  String country;
  String city;
  DateTime? eventDate;
  List<String> skills = [];

  Event(this.objectId, this.eventName, this.country, this.city, this.eventDate,
      this.skills);
}
