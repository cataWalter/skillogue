import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/message.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search_entity.dart';
import 'package:skillogue/entities/search_result.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/checkboxes/search/search_country_checkbox.dart';
import 'package:skillogue/widgets/checkboxes/search/search_gender_checkbox.dart';
import 'package:skillogue/widgets/checkboxes/search/search_language_checkbox.dart';
import 'package:skillogue/widgets/checkboxes/search/search_skill_checkbox.dart';

class SearchWidget extends StatefulWidget {
  Profile curProfile;
  Search curSearch;

  SearchWidget(this.curProfile, this.curSearch, {super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _searchResults = false;
  final controllerCity = TextEditingController();
  final controllerRegion = TextEditingController();

  final controllerPassword = TextEditingController();
  final controllerMinAge = TextEditingController();
  final controllerMaxAge = TextEditingController();
  late List<SearchResult> searchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSearch(),
    );
  }

  Widget getSearch() {
    if (_searchResults == false) {
      return getSearchForm();
    } else {
      return getSearchResults();
    }
  }

  Widget getSearchForm() {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: TextButton(
                            onPressed: putSkillDialog,
                            child: Text(
                              'Skills',
                              //style: TextStyle(color: Colors.white, fontSize: 30),
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 24,
                                  color: Colors
                                      .white), //GoogleFonts.openSans(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: TextButton(
                            onPressed: putLanguageDialog,
                            child: Text(
                              'Languages',
                              //style: TextStyle(color: Colors.white, fontSize: 30),
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 24,
                                  color: Colors
                                      .white), //GoogleFonts.openSans(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: TextButton(
                            onPressed: putCountryDialog,
                            child: Text(
                              'Countries',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 24,
                                  color: Colors
                                      .white), //GoogleFonts.openSans(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: TextField(
                      controller: controllerCity,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'City',
                        hintText: 'City',
                        hintStyle: TextStyle(color: Colors.blueGrey[400]),
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: TextField(
                      controller: controllerRegion,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Region',
                        hintText: 'Region',
                        hintStyle: TextStyle(color: Colors.blueGrey[400]),
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                    ),
                  ),
                ),
                spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 140.0),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: TextButton(
                        onPressed: putGenderDialog,
                        child: Text(
                          'Gender',
                          //style: TextStyle(color: Colors.white, fontSize: 30),
                          style: GoogleFonts.bebasNeue(
                              fontSize: 24,
                              color: Colors
                                  .white), //GoogleFonts.openSans(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "From",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: controllerMinAge,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: 'Minimum Age',
                          hintText: 'Minimum Age',
                          hintStyle: TextStyle(color: Colors.blueGrey[400]),
                          filled: true,
                          fillColor: Colors.grey[850],
                        ),
                      ),
                    ),
                    const Text(
                      "To",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: controllerMaxAge,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          labelText: 'Maximum Age',
                          hintText: 'Maximum Age',
                          hintStyle: TextStyle(
                            color: Colors.blueGrey[400],
                          ),
                          filled: true,
                          fillColor: Colors.grey[850],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 180,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.teal.shade300,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: TextButton(
                        child: Text(
                          'Search',
                          //style: TextStyle(color: Colors.white, fontSize: 30),
                          style: GoogleFonts.bebasNeue(
                              fontSize: 30,
                              color: Colors
                                  .white), //GoogleFonts.openSans(color: Colors.white),
                        ),
                        onPressed: () async {
                          saveSearch();
                          searchResults =
                              await findUsers(widget.curProfile.username);
                          Comparator<SearchResult> sortById =
                              (a, b) => b.lastLogin.compareTo(a.lastLogin);
                          searchResults.sort(sortById);
                          if (searchResults.isNotEmpty) {
                            setState(() {
                              _searchResults = true;
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("!No user found!"),
                                  content: const Text(
                                      "Try to look for people outside your sphere."),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 6,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    searchResults[index].fullName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    searchResultsLanguages(searchResults[index]),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              subtitle: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "${profileDescription(searchResults[index])}\nSkills: ${searchResultsSkills(searchResults[index])}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  sendNewMessage(searchResults[index].username);
                },
                icon: const Icon(Icons.message_outlined),
              ),
            ),
          ),
        );
      },
    ); //results
  }

  String searchResultsLanguages(SearchResult s) {
    String res = "${s.languages[0]} | ";
    for (var i = 1; i < s.languages.length - 1; i++) {
      res = "$res${s.languages[i]} | ";
    }
    res = res + s.languages[s.languages.length - 1];
    return res;
  }

  String searchResultsSkills(SearchResult s) {
    String res = "${s.skills[0]} | ";
    for (var i = 1; i < s.skills.length - 1; i++) {
      res = "$res${s.skills[i]} | ";
    }
    res = res + s.skills[s.skills.length - 1];
    return res;
  }

  String profileDescription(SearchResult s) {
    String res = "";
    if (s.gender.isNotEmpty) {
      res = "$res${s.gender}, ";
    }
    if (s.city.isNotEmpty) {
      res = "$res${s.city}, ";
    }
    if (s.region.isNotEmpty) {
      res = "$res${s.region}, ";
    }
    if (s.age > 0) {
      res = "$res${s.age.toString()}, ";
    }
    return res;
  }

  Widget spacer() {
    return const SizedBox(
      height: 30,
    );
  }

  void putSkillDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: skills.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: SearchSkillCheckbox(skills[index], widget.curSearch),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void putLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: SearchLanguageCheckbox(
                      languages[index], widget.curSearch),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void putCountryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      SearchCountryCheckbox(countries[index], widget.curSearch),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void putGenderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: genders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: SearchGenderCheckbox(genders[index], widget.curSearch),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void saveSearch() {
    if (controllerCity.text.trim() != "") {
      widget.curSearch.city = controllerCity.text.trim();
    }
    if (controllerRegion.text.trim() != "") {
      widget.curSearch.region = controllerRegion.text.trim();
    }
    widget.curSearch.username = widget.curProfile.username;
    if (controllerMaxAge.text.trim() != "") {
      widget.curSearch.maxAge = int.parse(controllerMaxAge.text.trim());
    }
    if (controllerMinAge.text.trim() != "") {
      widget.curSearch.minAge = int.parse(controllerMinAge.text.trim());
    }
    return;
  }

  void sendNewMessage(String destUsername) {
    final controllerNewMessage = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: 315,
            child: Column(
              children: [
                SizedBox(
                  child: TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      //border: const OutlineInputBorder(),
                      hintText: 'Send a new message to $destUsername',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    controller: controllerNewMessage,
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.teal.shade300,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: TextButton(
                            child: Text(
                              'Back',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 24,
                                  color: Colors
                                      .white), //GoogleFonts.openSans(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.teal.shade300,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: TextButton(
                            child: Text(
                              'Send',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 24,
                                  color: Colors
                                      .white), //GoogleFonts.openSans(color: Colors.white),
                            ),
                            onPressed: () {
                              sendMessage(widget.curProfile.username,
                                  destUsername, controllerNewMessage.text);
                              updateContacted(
                                  widget.curProfile.username, destUsername);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
