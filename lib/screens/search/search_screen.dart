import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/screens/profile/profile_overview.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/backend/profile_backend.dart';
import '../../utils/backend/profile_search_backend.dart';
import '../../utils/colors.dart';
import '../../utils/data.dart';
import '../../utils/utils.dart';

class SearchScreen extends StatefulWidget {
  Profile curProfile;
  ProfileSearch curSearch;
  List<Conversation> curConversations;

  SearchScreen(this.curProfile, this.curSearch, this.curConversations,
      {super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _searchIndex = 0;
  var controllerCity;
  var controllerMinAge;
  var controllerMaxAge;
  late List<Profile> searchResults;
  List<String> selectedCountries = [];
  List<String> selectedSkills = [];
  List<String> selectedLanguages = [];
  List<String> selectedGenders = [];
  late Profile lookupProfile;

  final _myBox = Hive.box("mybox");

  @override
  void initState() {
    super.initState();

    controllerCity = TextEditingController(text: widget.curSearch.city);
    if (widget.curSearch.minAge == null || widget.curSearch.minAge! < 18) {
      controllerMinAge = TextEditingController();
    } else {
      controllerMinAge =
          TextEditingController(text: widget.curSearch.minAge.toString());
    }
    if (widget.curSearch.maxAge == null || widget.curSearch.maxAge! > 99) {
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
    if (_searchIndex == 0) {
      return getSearchForm();
    } else if (_searchIndex == 1) {
      return getSearchResults();
    } else if (_searchIndex == 2) {
      return getProfileLookup();
    }
    return Container();
  }

  Widget getProfileLookup() {
    return ProfileOverview(lookupProfile);
  }

  Widget getSearchForm() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!widget.curProfile.isEmptyProfile()) {
            saveSearch();
            searchResults = await findUsers(widget.curProfile.email,
                widget.curSearch, widget.curConversations);
            Comparator<Profile> sortById =
                (a, b) => b.lastLogin.compareTo(a.lastLogin);
            searchResults.sort(sortById);
            if (searchResults.isNotEmpty) {
              setState(() {
                _searchIndex = 1;
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    title: Text("No users found!"),
                    content: Text(":'("),
                  );
                },
              );
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:
                      const Text("Some details about you are still missing!"),
                  content: const Text(
                      "Please, update your info in the SETTINGS before looking for others"),
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
        icon: const Icon(Icons.search),
        label: const Text("Search new friends"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 80,
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
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
                        buttonText: const Text(
                            'In what countries should they live in?'),
                        title: const Text('Countries'),
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
                    border: Border.all(
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
                        buttonText: const Text(
                            'What passions are you are you looking for?'),
                        title: const Text('Skills'),
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
                    border: Border.all(
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
                        buttonText:
                            const Text('What languages should they speak?'),
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
                    border: Border.all(
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
                        buttonText: const Text(
                            "Are you looking for a specific gender?"),
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
                      style: TextStyle(),
                      controller: controllerCity,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        labelText: "What's their city?",
                        hintText: 'City',
                        filled: true,
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
                    ),
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: controllerMinAge,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          labelText: 'Minimum age',
                          hintText: 'Minimum age',
                          filled: true,
                        ),
                      ),
                    ),
                    const Text(
                      "To",
                      style: TextStyle(),
                    ),
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: controllerMaxAge,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Maximum age',
                          hintText: 'Maximum age',
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
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
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue,
            ),
            child: ListTile(
              onTap: () async {
                lookupProfile =
                    await findProfileByEmail(searchResults[index].email);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Scaffold(body: ProfileOverview(lookupProfile))));
              },
              dense: true,
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: getRandomDarkColor(),
                child: Text(
                  initials(searchResults[index].name),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                searchResults[index].name,
              ),
              subtitle: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "\n${profileDescription(searchResults[index])}\n${profileDescription2(searchResults[index])}\n\nLanguages:\n${searchResultsLanguages(searchResults[index])}\n\nSkills:\n${searchResultsSkills(searchResults[index])}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  sendNewMessage(
                      searchResults[index].email, searchResults[index].name);
                },
                icon: Icon(Icons.message_outlined,
                    color: Colors.white.withOpacity(0.8)),
              ),
            ),
          ),
        );
      },
    ); //results
  }

  String searchResultsLanguages(s) {
    if (s.languages.length == 1) {
      return s.languages[0];
    }
    String res = "${s.languages[0]}, ";
    for (var i = 1; i < s.languages.length - 1; i++) {
      res = "$res${s.languages[i]}, ";
    }
    res = res + s.languages[s.languages.length - 1];
    return res;
  }

  String searchResultsSkills(s) {
    if (s.skills.length == 1) {
      return s.skills[0];
    }
    String res = "${s.skills[0]}, ";
    for (var i = 1; i < s.skills.length - 1; i++) {
      res = "$res${s.skills[i]}, ";
    }
    res = res + s.skills[s.skills.length - 1];
    return res;
  }

  String profileDescription(s) {
    String res = "";
    if (s.gender.isNotEmpty) {
      res = "$res${s.gender}, ";
    }
    if (s.age > 0) {
      res = "$res${s.age.toString()}";
    }
    return res;
  }

  String profileDescription2(s) {
    String res = "";
    if (s.city.isNotEmpty) {
      res = "$res${s.city}, ";
    }
    if (s.country.isNotEmpty) {
      res = "$res${s.country}";
    }
    return res;
  }

  Widget spacer() {
    return const SizedBox(
      height: 15,
    );
  }

  void saveSearch() {
    widget.curSearch.genders = selectedGenders;
    _myBox.put(lastGendersKey, selectedGenders);
    widget.curSearch.countries = selectedCountries;
    _myBox.put(lastCountriesKey, selectedCountries);
    widget.curSearch.languages = selectedLanguages;
    _myBox.put(lastLanguagesKey, selectedLanguages);
    widget.curSearch.skills = selectedSkills;
    if (controllerCity.text.toString().isEmpty) {
      widget.curSearch.city = "";
      _myBox.delete(lastCityKey);
    } else {
      widget.curSearch.city = controllerCity.text.trim();
      _myBox.put(lastCityKey, controllerCity.text.trim());
    }
    if (controllerMaxAge.text.toString().isEmpty) {
      widget.curSearch.maxAge = 100;
      _myBox.delete(lastMaxAge);
    }
    if (controllerMinAge.text.toString().isEmpty) {
      widget.curSearch.minAge = 17;
      _myBox.delete(lastMinAge);
    }
    if (controllerMaxAge.text.toString().isNotEmpty &&
        controllerMinAge.text.toString().isNotEmpty) {
      int maxAge = int.parse(controllerMaxAge.text.trim());
      int minAge = int.parse(controllerMinAge.text.trim());
      if (maxAge <= 99 && minAge >= 18 && maxAge >= minAge) {
        widget.curSearch.maxAge = maxAge;
        widget.curSearch.minAge = minAge;
        _myBox.put(lastMinAge, minAge);
        _myBox.put(lastMaxAge, maxAge);
      }
    }
    return;
  }

  void sendNewMessage(String destEmail, String destName) {
    widget.curConversations.add(Conversation(destEmail, destName, []));
    for (Conversation x in widget.curConversations) {
      if (x.destEmail == destEmail) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleConversationScreen(
                x, widget.curProfile, widget.curConversations, () {}),
          ),
        );
      }
    }
  }
}
