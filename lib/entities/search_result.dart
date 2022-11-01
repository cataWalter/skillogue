class SearchResult {
  String username;
  String fullName;
  List<String> skills = [];
  String country;
  String gender;
  List<String> languages = [];
  String city;
  int age;
  DateTime lastLogin;

  SearchResult(
      this.username,
      this.fullName,
      this.skills,
      this.country,
      this.gender,
      this.languages,
      this.city,
      this.age,
      this.lastLogin);
}
