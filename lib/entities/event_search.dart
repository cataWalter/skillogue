class EventSearch {
  String? country;
  String? city;
  DateTime? eventDate;
  List<String> skills = [];
}

EventSearch getOldSearch(myBox) {
  EventSearch oldSearch = EventSearch();/*
  if (myBox.get(lastCountriesKey) != null) {
    oldSearch.countries = myBox.get(lastCountriesKey);
  }
  if (myBox.get(lastSkillsKey) != null) {
    oldSearch.skills = myBox.get(lastSkillsKey);
  }
  if (myBox.get(lastLanguagesKey) != null) {
    oldSearch.languages = myBox.get(lastLanguagesKey);
  }
  if (myBox.get(lastGendersKey) != null) {
    oldSearch.genders = myBox.get(lastGendersKey);
  }
  if (myBox.get(lastCityKey) != null) {
    oldSearch.city = myBox.get(lastCityKey);
  }
  if (myBox.get(lastMinAge) != null) {
    oldSearch.minAge = myBox.get(lastMinAge);
  }
  if (myBox.get(lastMaxAge) != null) {
    oldSearch.maxAge = myBox.get(lastMaxAge);
  }*/
  return oldSearch;
}