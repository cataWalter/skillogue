import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/screens/profile/profile_overview.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_search_backend.dart';
import '../../utils/data.dart';
import '../../utils/utils.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

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
  final newMessageController = TextEditingController();

  final _myBox = Hive.box("mybox");

  @override
  void initState() {
    super.initState();

    controllerCity = TextEditingController(text: profileSearch.city);
    if (profileSearch.minAge == null || profileSearch.minAge! < 18) {
      controllerMinAge = TextEditingController();
    } else {
      controllerMinAge =
          TextEditingController(text: profileSearch.minAge.toString());
    }
    if (profileSearch.maxAge == null || profileSearch.maxAge! > 99) {
      controllerMaxAge = TextEditingController();
    } else {
      controllerMaxAge =
          TextEditingController(text: profileSearch.maxAge.toString());
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
      return ProfileOverview(lookupProfile);
    }
    return Container();
  }

  Widget getSearchForm() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!profile.isEmptyProfile()) {
            saveSearch();
            searchResults =
                await findUsers(profile.email, profileSearch, conversations);
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
                        initialValue: profileSearch.countries,
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
                addVerticalSpace(15),
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
                        initialValue: profileSearch.skills,
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
                addVerticalSpace(15),
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
                        initialValue: profileSearch.languages,
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
                addVerticalSpace(15),
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
                        initialValue: profileSearch.genders,
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
                addVerticalSpace(15),
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
                addVerticalSpace(15),
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
            left: 4,
            right: 4,
            bottom: 6,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue,
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return sendNewMessage(
                          searchResults[index].email,
                          searchResults[index].name,
                        );
                      },
                    );
                  },
                  title: Column(
                    children: [
                      addVerticalSpace(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " " + searchResults[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(4),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      rowProfileInfo(
                        profile,
                        12,
                        Colors.white.withOpacity(0.8),
                        true,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 3.0,
                          runSpacing: -10,
                          alignment: WrapAlignment.start,
                          children: chippies(searchResults[index].skills, 12.0),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 3.0,
                          runSpacing: -10,
                          children:
                              chippies(searchResults[index].languages, 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ); //results
  }

  void saveSearch() {
    profileSearch.genders = selectedGenders;
    _myBox.put(lastGendersKey, selectedGenders);
    profileSearch.countries = selectedCountries;
    _myBox.put(lastCountriesKey, selectedCountries);
    profileSearch.languages = selectedLanguages;
    _myBox.put(lastLanguagesKey, selectedLanguages);
    profileSearch.skills = selectedSkills;
    if (controllerCity.text.toString().isEmpty) {
      profileSearch.city = "";
      _myBox.delete(lastCityKey);
    } else {
      profileSearch.city = controllerCity.text.trim();
      _myBox.put(lastCityKey, controllerCity.text.trim());
    }
    if (controllerMaxAge.text.toString().isEmpty) {
      profileSearch.maxAge = 100;
      _myBox.delete(lastMaxAge);
    }
    if (controllerMinAge.text.toString().isEmpty) {
      profileSearch.minAge = 17;
      _myBox.delete(lastMinAge);
    }
    if (controllerMaxAge.text.toString().isNotEmpty &&
        controllerMinAge.text.toString().isNotEmpty) {
      int maxAge = int.parse(controllerMaxAge.text.trim());
      int minAge = int.parse(controllerMinAge.text.trim());
      if (maxAge <= 99 && minAge >= 18 && maxAge >= minAge) {
        profileSearch.maxAge = maxAge;
        profileSearch.minAge = minAge;
        _myBox.put(lastMinAge, minAge);
        _myBox.put(lastMaxAge, maxAge);
      }
    }
    return;
  }

  sendNewMessage(String destEmail, String destName) {
    return AlertDialog(
      title: Text("Send a message to $destName!"),
      content: TextField(
        controller: newMessageController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Type a message...",
        ),
      ),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            String newTextMessage = newMessageController.text.trim();
            if (newTextMessage.isNotEmpty) {
              newMessageController.clear();
              DateTime curDate = DateTime.now();
              databaseInsert('message', {
                'sender': profile.email,
                'receiver': destEmail,
                'text': newTextMessage,
                'date': curDate.toString(),
              });
              conversations.add(Conversation(destEmail, destName,
                  [SingleMessage(0, newTextMessage, curDate, true)]));
              setState(() {});
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  List<Widget> chippies(List<String> toChip, double size) {
    List<Widget> res = [];
    for (String s in toChip) {
      res.add(Chip(
          label: Text(
        s,
        style: TextStyle(fontSize: size),
      )));
    }
    return res;
  }
}
