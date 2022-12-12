import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

import '../../localizations/english.dart';
import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_search_backend.dart';
import '../../utils/data.dart';
import '../../utils/misc_functions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _searchIndex = 0;
  late TextEditingController controllerCity;
  late TextEditingController controllerMinAge;
  late TextEditingController controllerMaxAge;
  late List<Profile> searchResults;
  List<String> selectedCountries = [];
  List<String> selectedSkills = [];
  List<String> selectedLanguages = [];
  List<String> selectedGenders = [];
  late Profile lookupProfile;
  final newMessageController = TextEditingController();

  final _myBox = Hive.box(localDatabase);

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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: SpeedDial(
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
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        useRotationAnimation: true,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        activeForegroundColor: Colors.white,
        //activeBackgroundColor: Colors.yellow,
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        shape: const StadiumBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.search),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Search new friends',
            onTap: () async {
              if (!profile.isEmptyProfile()) {
                saveSearch();
                searchResults = await findUsers(
                    profile.email, profileSearch, conversations);
                searchResults.sort(sortById);
                if (searchResults.isNotEmpty) {
                  if (mounted) {
                    setState(() {
                      _searchIndex = 1;
                    });
                  }
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
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.star),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Saved searches',
            onTap: () => {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.radar),
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
            label: 'Around me',
            onTap: () => {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.accessibility),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Similar to me',
            onTap: () => {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.save),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            label: 'Save this search',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(newFunctionalityMessage),
              ),
            ), //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          /*
          SpeedDialChild(
            child: const Icon(Icons.accessibility),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'First',
            onTap: () => {},
            onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.brush),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Second',
            onTap: () => {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.margin),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            label: 'Show Snackbar',
            visible: true,
            onTap: () => {},
            onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
          ),*/
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
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
                    buttonText: const Text(whatCountryPerson),
                    title: const Text('Countries'),
                    buttonIcon: const Icon(
                      Icons.flag,
                    ),
                    searchIcon: const Icon(
                      Icons.search,
                    ),
                    items: countries.map((s) => MultiSelectItem(s, s)).toList(),
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
                    buttonText: const Text(whatPassionPerson),
                    title: const Text('Skills'),
                    buttonIcon: const Icon(
                      Icons.sports_tennis,
                    ),
                    searchIcon: const Icon(
                      Icons.search,
                    ),
                    items: skills.map((s) => MultiSelectItem(s, s)).toList(),
                    onConfirm: (values) {
                      selectedSkills = values.map((e) => e.toString()).toList();
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
                    buttonText: const Text(whatLanguagePerson),
                    title: const Text("Languages"),
                    buttonIcon: const Icon(
                      Icons.abc_outlined,
                    ),
                    searchIcon: const Icon(
                      Icons.search,
                    ),
                    items: languages.map((s) => MultiSelectItem(s, s)).toList(),
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
                    buttonText: const Text(whatGenderPerson),
                    title: const Text("Genders"),
                    buttonIcon: const Icon(
                      Icons.person,
                    ),
                    searchIcon: const Icon(
                      Icons.search,
                    ),
                    items: genders.map((s) => MultiSelectItem(s, s)).toList(),
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
                  controller: controllerCity,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    labelText: whatCityPerson,
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
                      labelText: minAge,
                      hintText: minAge,
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
                      labelText: maxAge,
                      hintText: maxAge,
                      filled: true,
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
                          searchResults[index].color,
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
                            " ${searchResults[index].name}",
                            style: const TextStyle(
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
                          children: chippies(searchResults[index].skills,
                              searchResults[index].languages, 12.0),
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

  sendNewMessage(String destEmail, String destName, Color color) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
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
