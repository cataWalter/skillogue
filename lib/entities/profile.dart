class Profile {
  String email;
  String name;
  String country;
  String city;
  String gender;
  int age;
  DateTime lastLogin;

  List<String> languages;
  List<String> skills;

  Profile(this.email, this.name, this.country, this.city, this.gender, this.age,
      this.lastLogin, this.languages, this.skills);

  late bool isLogged;

  bool isEmptyProfile() {
    return name.isEmpty ||
        country.isEmpty ||
        city.isEmpty ||
        gender.isEmpty ||
        age.toString().isEmpty ||
        skills.isEmpty ||
        languages.isEmpty;
  }
}


