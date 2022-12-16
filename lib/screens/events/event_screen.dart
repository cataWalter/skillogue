import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';


import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/my_multi_select_field.dart';
import 'package:skillogue/widgets/my_uni_select_field.dart';

import '../../entities/event.dart';
import '../../utils/backend/misc_backend.dart';
import '../../utils/data.dart';
import '../../utils/misc_functions.dart';
import 'event_overview.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final int _searchIndex = 0;

  late List<Event> searchResults;
  List<String> selectedCountries = [];
  List<String> selectedSkills = [];
  String selectedCity = "";
  late Event lookupEvent;
  final newMessageController = TextEditingController();

  final _myBox = Hive.box(localDatabase);


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
      return EventOverview(lookupEvent);
    }
    return Container();
  }

  Widget getSearchForm() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: SpeedDial(
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
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        useRotationAnimation: true,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
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
            label: 'Search new events',
            onTap: () async {

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
            child: const Icon(Icons.event_available),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Create event',
            onTap: () => {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.save),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            label: 'Save this search',
            onTap: () => {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
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
      body: listViewCreator([
        MyMultiSelectField(countries, const [], 'In what countries should the event be held?', "Countries", selectedCountries, Icons.flag),
        MyMultiSelectField(skills, const [], 'What passions are you looking for?', "Skills", selectedSkills, Icons.sports_tennis),
        MyUniSelectField(cities, "Cities", "What's the city?", "City", selectedCity, Icons.location_city),

      ]),
      /*body: SingleChildScrollView(
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
                    buttonText:
                        const Text('In what countries should the event be held?'),
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
                    buttonText:
                        const Text('What passions are you looking for?'),
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
                    labelText: "What's the city?",
                    hintText: 'City',
                    filled: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),*/
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
                    /*showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return sendNewMessage(
                          searchResults[index].email,
                          searchResults[index].name,
                        );
                      },
                    );*/
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
                          children: chippies(searchResults[index].skills, 12.0),
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
    profileSearch.countries = selectedCountries;
    _myBox.put(lastProfileSearchCountriesKey, selectedCountries);
    profileSearch.skills = selectedSkills;
    if (selectedCity.isEmpty) {
      profileSearch.city = "";
      _myBox.delete(lastProfileSearchCityKey);
    } else {
      profileSearch.city = selectedCity;
      _myBox.put(lastProfileSearchCityKey, selectedCity);
    }
  }

  sendNewMessage(String destEmail, String destName) {
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
                conversations.add(Conversation(destEmail, destName, const Color(0x00000000),
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
