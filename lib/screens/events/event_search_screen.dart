/*import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/constants.dart';

import '../../entities/event.dart';
import '../../localizations/english.dart';
import '../../utils/backend/misc_backend.dart';
import '../../utils/data.dart';
import '../../utils/misc_functions.dart';
import '../../widgets/mono_dropdown.dart';
import '../../widgets/multi_dropdown.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final int _searchIndex = 0;

  late List<Event> eventSearchResults;

  TextEditingController dateInput = TextEditingController();
  final newMessageController = TextEditingController();
  final _myBox = Hive.box(localDatabase);

  @override
  void initState() {
    super.initState();
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
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.white,
            label: 'Search new events',
            onTap: () async {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.star),
            backgroundColor: Colors.blue[900],
            foregroundColor: Colors.white,
            label: 'Saved searches',
            onTap: () => {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.radar),
            backgroundColor: Colors.lightBlue,
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
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
            label: 'Save this search',
            onTap: () => {},
            //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.cleaning_services),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Clean current search',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(newFunctionalityMessage),
              ),
            ), //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.settings_suggest_outlined),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Suggest search',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(newFunctionalityMessage),
              ),
            ), //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
        ],
      ),
      body: listViewCreator([
        MultiDropdown(
          countries,
          whatCountryEvent,
          "Country",
          activeEventSearch.countries,
          Icons.add_location,
          (value) {
            setState(() {
              activeEventSearch.countries = value;
            });
          },
        ),
        MultiDropdown(
          skills,
          whatPassionPerson,
          "Passions",
          activeEventSearch.skills,
          Icons.sports_tennis,
          (value) {
            setState(() {
              activeEventSearch.skills = value;
            });
          },
        ),
        MonoDropdown(
          cities,
          "Cities",
          activeEventSearch.city.isNotEmpty
              ? activeEventSearch.city
              : whatCityEvent,
          Icons.location_city,
          (value) {
            setState(() {
              activeEventSearch.city = value;
            });
          },
        ),
        SizedBox(
          height: 50,
          child: TextField(
            controller: dateInput,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(40.0),
              ),
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : const Color.fromRGBO(235, 235, 235, 1),
              hintText: "Data",
              hintStyle:
                  TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
              filled: true,
              suffixIcon: const Icon(Icons.date_range,
                  color: Color.fromRGBO(129, 129, 129, 1)),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 5));
              if (pickedDate != null) {
                setState(() {
                  dateInput.text = parseDate(pickedDate);
                });
              } else {}
            },
          ),
        )
      ]),
    );
  }

  Widget getSearchResults() {
    return ListView.builder(
      itemCount: eventSearchResults.length,
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
                            " ${eventSearchResults[index].name}",
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
                          children:
                              chippies(eventSearchResults[index].skills, 12.0),
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
    _myBox.put(lastEventSearchCountriesKey, activeEventSearch.countries);
    if (activeEventSearch.city.isEmpty) {
      activeEventSearch.city = "";
      _myBox.delete(lastEventSearchCityKey);
    } else {
      _myBox.put(lastEventSearchCityKey, activeEventSearch.city);
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
                conversations.add(Conversation(
                    destEmail,
                    destName,
                    const Color(0x00000000),
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
      res.add(
        Chip(
          label: Text(
            s,
            style: TextStyle(fontSize: size),
          ),
        ),
      );
    }
    return res;
  }
}
*/