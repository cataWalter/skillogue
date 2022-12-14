import '../utils/constants.dart';

class ProfileSearch {
  List<String> skills = [];
  List<String> countries = [];
  List<String> languages = [];
  List<String> genders = [];
  String? city;
  int? minAge;
  int? maxAge;
}

ProfileSearch getOldSearch(myBox) {
  ProfileSearch oldSearch = ProfileSearch();
  if (myBox.get(lastProfileSearchCountriesKey) != null) {
    oldSearch.countries = myBox.get(lastProfileSearchCountriesKey);
  }
  if (myBox.get(lastProfileSearchSkillsKey) != null) {
    oldSearch.skills = myBox.get(lastProfileSearchSkillsKey);
  }
  if (myBox.get(lastProfileSearchLanguagesKey) != null) {
    oldSearch.languages = myBox.get(lastProfileSearchLanguagesKey);
  }
  if (myBox.get(lastProfileSearchGendersKey) != null) {
    oldSearch.genders = myBox.get(lastProfileSearchGendersKey);
  }
  if (myBox.get(lastProfileSearchCityKey) != null) {
    oldSearch.city = myBox.get(lastProfileSearchCityKey);
  }
  if (myBox.get(lastProfileSearchMinAge) != null) {
    oldSearch.minAge = myBox.get(lastProfileSearchMinAge);
  }
  if (myBox.get(lastProfileSearchMaxAge) != null) {
    oldSearch.maxAge = myBox.get(lastProfileSearchMaxAge);
  }
  return oldSearch;
}
