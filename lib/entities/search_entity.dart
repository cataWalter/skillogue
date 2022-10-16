
class Search {
  String? username;
  List<String> skills = [];
  List<String> countries = [];
  List<String> languages = [];
  String? city;
  String? region;
  int? sex;
  int? minAge;
  int? maxAge;
  int? minTimezone;
  int? maxTimezone;

  Search();

  @override
  String toString() {
    return 'Search{username: $username, skills: $skills, countries: $countries, languages: $languages, city: $city, region: $region, sex: $sex, minAge: $minAge, maxAge: $maxAge, minTimezone: $minTimezone, maxTimezone: $maxTimezone}';
  }

  void addSkill(String text) {
    if (!skills.contains(text)) {
      skills.add(text);
    }
  }

  void delSkill(String text) {
    if (skills.contains(text)) {
      skills.remove(text);
    }
  }


}

/*
Table Search {
  username varchar
  skillName varchar //list
  country varchar //list
  language varchar //list
  city varchar
  region varchar
  sex int
  minAge int
  maxAge int
  minTimezone int
  maxTimezone int
}
 */
