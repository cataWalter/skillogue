
import 'dart:ui';

class ProfileSearch {
  List<String> skills = [];
  List<String> countries = [];
  List<String> languages = [];
  List<String> genders = [];
  String city = "";
  int? minAge;
  int? maxAge;

  ProfileSearch();

  void clean() {
    skills = [];
    countries = [];
    languages = [];
    genders = [];
    city = "";
    minAge = null;
    maxAge = null;
  }

  copy(){
    ProfileSearch res = ProfileSearch();
    res.skills = skills;
    res.countries = countries;
    res.languages = languages;
    res.genders = genders;
    res.city = city;
    res.minAge = minAge;
    res.maxAge = maxAge;
    return res;
  }
}

class SavedProfileSearch{
  String name;
  ProfileSearch search;

  SavedProfileSearch(this.name, this.search);
}


