import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skillogue/entities/message.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search.dart';
import 'package:skillogue/entities/search_result.dart';
import 'package:skillogue/utils/constants.dart';

class SearchWidget extends StatefulWidget {
  Profile curProfile;
  Search curSearch;

  SearchWidget(this.curProfile, this.curSearch, {super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _searchResults = false;
  var controllerCity;
  var controllerMinAge;
  var controllerMaxAge;
  late List<SearchResult> searchResults;
  List<String> selectedCountries = [];
  List<String> selectedSkills = [];
  List<String> selectedLanguages = [];
  List<String> selectedGenders = [];

  @override
  void initState() {
    super.initState();
    controllerCity = TextEditingController(text: widget.curSearch.city);
    if (widget.curSearch.minAge == null) {
      controllerMinAge = TextEditingController();
    } else {
      controllerMinAge =
          TextEditingController(text: widget.curSearch.minAge.toString());
    }
    if (widget.curSearch.maxAge == null) {
      controllerMaxAge = TextEditingController();
    } else {
      controllerMaxAge =
          TextEditingController(text: widget.curSearch.maxAge.toString());
    }
  }

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
                  height: 45,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        initialValue: widget.curSearch.countries,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: const Text("Countries"),
                        title: const Text("Countries"),
                        buttonIcon: const Icon(
                          Icons.flag,
                        ),
                        searchIcon: const Icon(
                          Icons.search,
                        ),
                        items: countries
                            .map((s) => MultiSelectItem(s, s))
                            .toList(),
                        onConfirm: (values) {
                          selectedCountries =
                              values.map((e) => e.toString()).toList();
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              selectedCountries.remove(value.toString());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        initialValue: widget.curSearch.skills,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: const Text("Skills"),
                        title: const Text("Skills"),
                        buttonIcon: const Icon(
                          Icons.sports_tennis,
                        ),
                        searchIcon: const Icon(
                          Icons.search,
                        ),
                        items:
                            skills.map((s) => MultiSelectItem(s, s)).toList(),
                        onConfirm: (values) {
                          selectedSkills =
                              values.map((e) => e.toString()).toList();
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              selectedSkills.remove(value.toString());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        initialValue: widget.curSearch.languages,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: const Text("Languages"),
                        title: const Text("Languages"),
                        buttonIcon: const Icon(
                          Icons.abc_outlined,
                        ),
                        searchIcon: const Icon(
                          Icons.search,
                        ),
                        items: languages
                            .map((s) => MultiSelectItem(s, s))
                            .toList(),
                        onConfirm: (values) {
                          selectedLanguages =
                              values.map((e) => e.toString()).toList();
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              selectedLanguages.remove(value.toString());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        initialValue: widget.curSearch.genders,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: const Text("Genders"),
                        title: const Text("Genders"),
                        buttonIcon: const Icon(
                          Icons.person,
                        ),
                        searchIcon: const Icon(
                          Icons.search,
                        ),
                        items:
                            genders.map((s) => MultiSelectItem(s, s)).toList(),
                        onConfirm: (values) {
                          selectedGenders =
                              values.map((e) => e.toString()).toList();
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              selectedGenders.remove(value.toString());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
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
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
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
                          if (!widget.curProfile.isEmptyProfile()) {
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
                                    title: const Text("No users found!"),
                                    content: const Text(":'("),
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      "Some details about you are still missing!"),
                                  content: const Text(
                                      "Please, set them before looking for others"),
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

    if (s.age > 0) {
      res = "$res${s.age.toString()}, ";
    }
    return res;
  }

  Widget spacer() {
    return const SizedBox(
      height: 15,
    );
  }

  void saveSearch() {
    if (selectedGenders.isNotEmpty) {
      widget.curSearch.genders = selectedGenders;
    }
    if (selectedCountries.isNotEmpty) {
      widget.curSearch.countries = selectedCountries;
    }
    if (selectedLanguages.isNotEmpty) {
      widget.curSearch.languages = selectedLanguages;
    }
    if (selectedSkills.isNotEmpty) {
      widget.curSearch.countries = selectedSkills;
    }
    if (controllerCity.text.trim() != "") {
      widget.curSearch.city = controllerCity.text.trim();
    }
    if (controllerMaxAge.text.trim() != "") {
      int maxAge = int.parse(controllerMaxAge.text.trim());
      if (maxAge <= 99) widget.curSearch.maxAge = maxAge;
    }
    if (controllerMinAge.text.trim() != "") {
      int minAge = int.parse(controllerMinAge.text.trim());
      if (minAge >= 18) widget.curSearch.minAge = minAge;
    }
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
