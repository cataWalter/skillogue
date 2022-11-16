import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/entities/profile_search_result.dart';
import 'package:skillogue/screens/messages/conversation_screen.dart';
import 'package:skillogue/screens/profile/profile_overview.dart';
import 'package:skillogue/utils/constants.dart';

class EventScreen extends StatefulWidget {
  Profile curProfile;
  ProfileSearch curSearch;
  List<Conversation> curConversations;

  EventScreen(this.curProfile, this.curSearch, this.curConversations,
      {super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _searchIndex = 0;
  var controllerCity;
  var controllerMinAge;
  var controllerMaxAge;
  late List<ProfileSearchResult> searchResults;
  List<String> selectedCountries = [];
  List<String> selectedSkills = [];
  late Profile lookupProfile;
  TextEditingController dateInput = TextEditingController();

  final _myBox = Hive.box("mybox");

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
      floatingActionButton: Row(children: [
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              if (!widget.curProfile.isEmptyProfile()) {
                saveSearch();
                searchResults = await findUsers(widget.curProfile.username,
                    widget.curSearch, widget.curConversations);
                Comparator<ProfileSearchResult> sortById =
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
                      title: const Text(
                          "Some details about you are still missing!"),
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
            icon: Icon(
              Icons.search,
            ),
            label: Text("Search"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 130.0),
          child: FloatingActionButton.extended(
            onPressed: () {},
            icon: Icon(
              Icons.add,
            ),
            label: Text("Create"),
          ),
        ),
      ]),
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: TextField(
                      style: TextStyle(color: Colors.grey[300]),
                      controller: controllerCity,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'City',
                        hintText: 'City',
                        labelStyle: textFieldStyleWithOpacity,
                        hintStyle: textFieldStyleWithOpacity,
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                    ),
                  ),
                ),
                spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: TextField(
                      style: TextStyle(color: Colors.grey[300]),
                      controller: dateInput,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Date',
                        hintText: 'Date',
                        labelStyle: textFieldStyleWithOpacity,
                        hintStyle: textFieldStyleWithOpacity,
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(DateTime.now().year + 5));
                        if (pickedDate != null) {
                          setState(() {
                            dateInput.text = formatDatePicker(pickedDate);
                          });
                        } else {}
                      },
                    ),
                  ),
                ),
                spacer(),
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

  String formatDatePicker(DateTime pickedDate) {
    return "${pickedDate.day} - ${pickedDate.month} - ${pickedDate.year}";
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
              onTap: () async {
                lookupProfile =
                    await queryByUsername(searchResults[index].username);
                setState(() {
                  _searchIndex = 2;
                });
              },
              dense: true,
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: getRandomDarkColor(),
                child: Text(
                  initials("met"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              title: Text(
                "Metallica Rock Tour 2022",
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "\n9pm, 19/11/2022\nStadio San Siro, Milano\n\nLorem ipsum dolor sit amet. Id omnis nihil sit dignissimos consequatur hic nisi inventore vel aperiam delectus ea eius voluptas ut ducimus Quis. Ab quia debitis ut dolor ducimus aut eius nesciunt. Sit quam praesentium et eius itaque est quis reiciendis eos provident officia aut ipsa laudantium! Qui doloremque fugit et adipisci nesciunt aut cumque molestias et possimus reprehenderit ex sint quasi.",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  sendNewMessage(searchResults[index].username);
                },
                icon: Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ),
        );
      },
    ); //results
  }

  String searchResultsLanguages(ProfileSearchResult s) {
    if (s.languages.length == 1) {
      return s.languages[0];
    }
    String res = "${s.languages[0]} | ";
    for (var i = 1; i < s.languages.length - 1; i++) {
      res = "$res${s.languages[i]} | ";
    }
    res = res + s.languages[s.languages.length - 1];
    return res;
  }

  String searchResultsSkills(ProfileSearchResult s) {
    if (s.skills.length == 1) {
      return s.skills[0];
    }
    String res = "${s.skills[0]} | ";
    for (var i = 1; i < s.skills.length - 1; i++) {
      res = "$res${s.skills[i]} | ";
    }
    res = res + s.skills[s.skills.length - 1];
    return res;
  }

  String profileDescription(ProfileSearchResult s) {
    String res = "";
    if (s.gender.isNotEmpty) {
      res = "$res${s.gender} | ";
    }
    if (s.age > 0) {
      res = "$res${s.age.toString()}";
    }
    return res;
  }

  String profileDescription2(ProfileSearchResult s) {
    String res = "";
    if (s.city.isNotEmpty) {
      res = "$res${s.city} | ";
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
    widget.curSearch.countries = selectedCountries;
    _myBox.put(lastCountriesKey, selectedCountries);

    widget.curSearch.skills = selectedSkills;
    if (controllerCity.text.toString().isEmpty) {
      widget.curSearch.city = "";
      _myBox.delete(lastCityKey);
    } else {
      widget.curSearch.city = controllerCity.text.trim();
      _myBox.put(lastCityKey, controllerCity.text.trim());
    }
    if (controllerMaxAge.text.toString().isEmpty) {
      widget.curSearch.maxAge = 99;
      _myBox.delete(lastMaxAge);
    }
    if (controllerMinAge.text.toString().isEmpty) {
      widget.curSearch.minAge = 18;
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

  void sendNewMessage(String destUsername) {
    widget.curConversations.add(Conversation(destUsername, []));
    for (Conversation x in widget.curConversations) {
      if (x.username == destUsername) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
                x, widget.curProfile, widget.curConversations, () {}),
          ),
        );
      }
    }
  }

  void sendMessageLocal(String source, String dest, String text) async {
    widget.curConversations.add(
      Conversation(
        dest,
        [
          SingleMessage(
            "",
            text,
            DateTime.now(),
            true,
          )
        ],
      ),
    );
  }
}
