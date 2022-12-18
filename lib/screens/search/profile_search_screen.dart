import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/colors.dart';

import '../../localizations/english.dart';
import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_search_backend.dart';
import '../../utils/data.dart';
import '../../utils/misc_functions.dart';
import '../../widgets/mono_dropdown.dart';
import '../../widgets/multi_dropdown.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int profileSearchIndex = 0;

  RangeValues _currentRangeValues = const RangeValues(18, 99);
  late List<Profile> profileSearchResults;
  final newMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (activeProfileSearch.minAge != null &&
        activeProfileSearch.maxAge != null) {
      _currentRangeValues = RangeValues(activeProfileSearch.minAge!.toDouble(),
          activeProfileSearch.maxAge!.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSearch(),
    );
  }

  Widget getSearch() {
    if (profileSearchIndex == 0) {
      return getSearchForm();
    } else if (profileSearchIndex == 1) {
      return getSearchResults();
    }
    return Container();
  }

  f() {
    getBlurDialog(context, "No users found!", ":'(");
  }

  Widget getSearchForm() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: SpeedDial(
        activeBackgroundColor: Colors.blue,
        label: const Text("Start here"),
        icon: Icons.add_outlined,
        activeIcon: Icons.close_outlined,
        spacing: 3,
        openCloseDial: ValueNotifier<bool>(false),
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        buttonSize: const Size(56.0, 56.0),
        childrenButtonSize: const Size(56.0, 56.0),
        visible: true,
        direction: SpeedDialDirection.up,
        switchLabelPosition: false,
        closeManually: false,
        renderOverlay: true,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        useRotationAnimation: true,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        activeForegroundColor: Colors.white,
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        shape: const StadiumBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.search),
            backgroundColor: rainbowColors[0],
            foregroundColor: Colors.white,
            label: 'Search new friends',
            onTap: () async {
              profileSearchResults = await findUsers(
                  profile.email, activeProfileSearch, conversations);
              profileSearchResults.sort(sortById);
              if (profileSearchResults.isNotEmpty) {
                if (mounted) {
                  setState(() {
                    profileSearchIndex = 1;
                  });
                }
              } else {
                f();
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.star),
            backgroundColor: rainbowColors[1],
            foregroundColor: Colors.white,
            label: 'Saved searches',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ClipRect(
                    // <-- clips to the 200x200 [Container] below
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10.0,
                        sigmaY: 10.0,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 200.0,
                        height: 200.0,
                        child: Wrap(
                          spacing: 20.0,
                          runSpacing: 20,
                          children: f1(),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          /*SpeedDialChild(
            child: const Icon(Icons.radar),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            label: 'Around me',
            onTap: () => {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.accessibility),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Similar to me',
            onTap: () => {},
          ),*/
          SpeedDialChild(
              child: const Icon(Icons.save),
              backgroundColor: rainbowColors[2],
              foregroundColor: Colors.white,
              label: 'Save this search',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AlertDialog(
                        title: Text("Do you want to save this search?"),
                        content: TextField(
                          controller: newMessageController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            fillColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromRGBO(30, 30, 30, 1)
                                    : const Color.fromRGBO(235, 235, 235, 1),
                            hintText: "How do you want to name it?",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).hintColor),
                            filled: true,
                            //suffixIcon: const Icon(Icons.message,color: Color.fromRGBO(129, 129, 129, 1)),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              if (newMessageController.text.isNotEmpty) {
                                var z = activeProfileSearch;
                                savedProfileSearch.add(
                                  SavedProfileSearch(
                                    newMessageController.text,
                                    activeProfileSearch.copy(),
                                  ),
                                );
                                newMessageController.clear();
                                var x = savedProfileSearch;
                                Navigator.of(context).pop();
                              } else {
                                showSnackBar(
                                    "Give it a name cowboy! 🤠", context);
                              }
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.cleaning_services),
              backgroundColor: rainbowColors[3],
              foregroundColor: Colors.white,
              label: 'Clean current search',
              onTap: () {
                setState(() {
                  activeProfileSearch.clean();
                  _currentRangeValues =
                      RangeValues(18.toDouble(), 99.toDouble());
                });
              }),
          /*SpeedDialChild(
            child: const Icon(Icons.settings_suggest_outlined),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Suggest search',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(newFunctionalityMessage),
              ),
            ),
          ),*/
        ],
      ),
      body: listViewCreator(
        [
          MultiDropdown(
            countries,
            whatCountryPerson,
            "Country",
            activeProfileSearch.countries,
            Icons.add_location,
            (value) {
              setState(() {
                activeProfileSearch.countries = value;
              });
            },
          ),
          MultiDropdown(
            skills,
            whatPassionPerson,
            "Passions",
            activeProfileSearch.skills,
            Icons.sports_tennis,
            (value) {
              setState(() {
                activeProfileSearch.skills = value;
              });
            },
          ),
          MultiDropdown(
            languages,
            whatLanguagePerson,
            "Languages",
            activeProfileSearch.languages,
            Icons.abc,
            (value) {
              setState(() {
                activeProfileSearch.languages = value;
              });
            },
          ),
          MultiDropdown(
            genders,
            whatGenderPerson,
            "Genders",
            activeProfileSearch.genders,
            Icons.female,
            (value) {
              setState(() {
                activeProfileSearch.genders = value;
              });
            },
          ),
          MonoDropdown(
            cities,
            "Cities",
            activeProfileSearch.city.isNotEmpty
                ? activeProfileSearch.city
                : whatCityPerson,
            Icons.location_city,
            (value) {
              setState(() {
                activeProfileSearch.city = value;
              });
            },
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : const Color.fromRGBO(235, 235, 235, 1),
            ),
            child: TextFormField(
              style: const TextStyle(color: Color.fromRGBO(94, 94, 94, 1)),
              initialValue: "What's their age?",
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.mail),
              ),
            ),
          ),
          RangeSlider(
            activeColor: Colors.black,
            inactiveColor: Colors.grey,
            values: _currentRangeValues,
            max: 99,
            min: 18,
            divisions: 80,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
                activeProfileSearch.minAge = _currentRangeValues.start.toInt();
                activeProfileSearch.maxAge = _currentRangeValues.end.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  List<Widget> f1() {
    List<Widget> res = [];
    for (int i = 0; i < savedProfileSearch.length; i++) {
      res.add(FloatingActionButton(
        backgroundColor: rainbowColors[i % 7],
        onPressed: () {
          int min = activeProfileSearch.minAge ?? 18;
          int max = activeProfileSearch.maxAge ?? 99;
          setState(() {
            activeProfileSearch = savedProfileSearch[i].search.copy();
            _currentRangeValues = RangeValues(min.toDouble(), max.toDouble());
          });
          Navigator.of(context).pop();
        },
        child: Text(savedProfileSearch[i].name),
      ));
      res.add(TextButton(

        onPressed: () {
          int min = activeProfileSearch.minAge ?? 18;
          int max = activeProfileSearch.maxAge ?? 99;
          setState(() {
            activeProfileSearch = savedProfileSearch[i].search.copy();
            _currentRangeValues = RangeValues(min.toDouble(), max.toDouble());
          });
          Navigator.of(context).pop();
        },
        child: Text(savedProfileSearch[i].name),
      ));
    }
    return res;
  }

  Widget getSearchResults() {
    return ListView.builder(
      itemCount: profileSearchResults.length,
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
                          profileSearchResults[index].email,
                          profileSearchResults[index].name,
                          profileSearchResults[index].color,
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
                            " ${profileSearchResults[index].name}",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      addVerticalSpace(4),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      rowProfileInfo(
                        profileSearchResults[index],
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
                          children: chippies(profileSearchResults[index].skills,
                              profileSearchResults[index].languages, 12.0),
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

  sendNewMessage(String destEmail, String destName, Color color) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        title: Text("Send a message to $destName!"),
        content: TextField(
          controller: newMessageController,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40.0),
            ),
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(30, 30, 30, 1)
                : const Color.fromRGBO(235, 235, 235, 1),
            hintText: "Type a message...",
            hintStyle:
                TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
            filled: true,
            suffixIcon: const Icon(Icons.message,
                color: Color.fromRGBO(129, 129, 129, 1)),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
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
                conversations.add(Conversation(destEmail, destName, color,
                    [SingleMessage(0, newTextMessage, curDate, true, false)]));
                setState(() {});
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  List<Widget> chippies(
      List<String> toChip1, List<String> toChip2, double size) {
    List<Widget> res = [];
    for (String item in toChip1) {
      res.add(
        Chip(
          backgroundColor: Colors.blue[800],
          label: Text(
            item,
            style: TextStyle(fontSize: size, color: Colors.white),
          ),
        ),
      );
    }
    for (String item in toChip2) {
      res.add(
        Chip(
          backgroundColor: Colors.green,
          label: Text(
            item,
            style: TextStyle(fontSize: size, color: Colors.white),
          ),
        ),
      );
    }
    return res;
  }
}
