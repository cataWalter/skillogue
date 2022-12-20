import 'package:skillogue/entities/profile.dart';


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

  ProfileSearch copy() {
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

int getSkillIndex(String skill, List<String> skills) {
  for (int i = 0; i < skills.length; i++) {
    if (skills[i] == skill) {
      return i;
    }
  }
  return -1;
}

double evaluateSimilarity(String skill1, String skill2, List<String> skills, List<List<double>> skillSimilarity) {
  int a = getSkillIndex(skill1, skills);
  int b = getSkillIndex(skill2, skills);
  return skillSimilarity[a][b];
}

List<int> findMax(int howMany, List<double> points) {
  List<double> b = [...points];
  b.sort((b, a) => a.compareTo(b));
  double min = b[howMany - 1];
  List<int> res = [];
  for (int i = 0; i < points.length; i++) {
    if (points[i] >= min) res.add(i);
  }
  return res;
}

suggestFeature(List<String> mine, int howMany,  List<String> skills, List<List<double>> skillSimilarity) {
  List<double> res1 = [];
  double res2;
  for (String skill1 in skills) {
    res2 = 0;
    if (!mine.contains(skill1)) {
      for (String skill2 in mine) {
        res2 += evaluateSimilarity(skill1, skill2, skills, skillSimilarity);
      }
    }
    res1.add(res2);
  }
  List<int> newSkillIndexes = findMax(howMany, res1);
  List<String> res = [];
  for (int x in newSkillIndexes) {
    res.add(skills[x]);
  }
  return res;
}

class SavedProfileSearch {
  String name;
  ProfileSearch search;

  SavedProfileSearch(this.name, this.search);
}
