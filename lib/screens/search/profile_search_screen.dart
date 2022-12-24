
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/screens/search/result_search_screen.dart';
import 'package:skillogue/screens/search/saved_search_screen.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_search_backend.dart';
import '../../utils/data.dart';
import '../../utils/localization.dart';
import '../../utils/misc_functions.dart';
import '../../widgets/mono_dropdown.dart';
import '../../widgets/multi_dropdown.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              appName,
              style: GoogleFonts.bebasNeue(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            SpeedDial(
              activeBackgroundColor: Colors.blue,
              label: Text(AppLocale.startHere.getString(context)),
              icon: Icons.add_outlined,
              activeIcon: Icons.close_outlined,
              spacing: 3,
              openCloseDial: ValueNotifier<bool>(false),
              childPadding: const EdgeInsets.all(5),
              spaceBetweenChildren: 4,
              buttonSize: const Size(40.0, 40.0),
              childrenButtonSize: const Size(56.0, 56.0),
              visible: true,
              direction: SpeedDialDirection.down,
              switchLabelPosition: false,
              closeManually: false,
              renderOverlay: true,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              useRotationAnimation: true,
              //tooltip: 'Open Speed Dial',
              //heroTag: 'speed-dial-hero-tag',
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey[800],
              activeForegroundColor: Colors.white,
              elevation: 0,
              animationCurve: Curves.elasticInOut,
              isOpenOnStart: false,
              shape: const StadiumBorder(),
              children: dials(),
            )
            /*Row(
                      children: [
                        Text(
                          profile.name,
                          style: GoogleFonts.bebasNeue(
                              fontSize: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    )*/
          ],
        ),
      ),

      body: Padding(
        padding: tabletMode ? tabletEdgeInsets : phoneEdgeInsets,
        child: listViewCreator(
          [
            MultiDropdown(
              countries,
              AppLocale.theirCountriesPerson.getString(context),
              AppLocale.country.getString(context),
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
              AppLocale.theirPassionsPerson.getString(context),
              AppLocale.skills.getString(context),
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
              AppLocale.theirLanguagesPerson.getString(context),
              AppLocale.languages.getString(context),
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
              AppLocale.theirGendersPerson.getString(context),
              AppLocale.genders.getString(context),
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
              AppLocale.cities.getString(context),
              activeProfileSearch.city.isNotEmpty
                  ? activeProfileSearch.city
                  : AppLocale.theirCityPerson.getString(context),
              Icons.location_city,
              (value) {
                setState(() {
                  activeProfileSearch.city = value;
                });
              },
            ),
            SizedBox(
              height: 50,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : const Color.fromRGBO(235, 235, 235, 1),
                  hintText: AppLocale.theirAge.getString(context),
                  hintStyle: TextStyle(
                      fontSize: 16, color: Theme.of(context).hintColor),
                  filled: true,
                  suffixIcon: const Icon(Icons.numbers,
                      color: Color.fromRGBO(129, 129, 129, 1)),
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
                  activeProfileSearch.minAge =
                      _currentRangeValues.start.toInt();
                  activeProfileSearch.maxAge = _currentRangeValues.end.toInt();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void nextScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultSearchScreen(profileSearchResults),
      ),
    );
  }

  dials() {
    var res = [
      SpeedDialChild(
        child: const Icon(Icons.search),
        backgroundColor: rainbowColors[0],
        foregroundColor: Colors.white,
        label: AppLocale.searchNewFriends.getString(context),
        onTap: () async {
          profileSearchResults = await findUsers(
              profile.email, activeProfileSearch, conversations, context);
          profileSearchResults.sort(sortById);
          if (profileSearchResults.isNotEmpty) {
            if (mounted) {
              nextScreen();
            }
          } else {
            getBlurDialog(context, AppLocale.noUsers.getString(context), "😢");
          }
        },
      ),
      SpeedDialChild(
        child: const Icon(Icons.star),
        backgroundColor: rainbowColors[1],
        foregroundColor: Colors.white,
        label: AppLocale.savedSearches.getString(context),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SavedSearchScreen(),
            ),
          );
        },
      ),
      SpeedDialChild(
          child: const Icon(Icons.save),
          backgroundColor: rainbowColors[2],
          foregroundColor: Colors.white,
          label: AppLocale.saveSearch.getString(context),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocale.saveSearch.getString(context)),
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
                      hintText: AppLocale.nameSearch.getString(context),
                      hintStyle: TextStyle(
                          fontSize: 16, color: Theme.of(context).hintColor),
                      filled: true,
                      //suffixIcon: const Icon(Icons.message,color: Color.fromRGBO(129, 129, 129, 1)),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(AppLocale.no.getString(context)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(AppLocale.yes.getString(context)),
                      onPressed: () {
                        String newName = newMessageController.text;
                        newMessageController.clear();
                        if (newName.isNotEmpty) {
                          if (savedProfileSearch
                              .any((element) => element.name == newName)) {
                            showSnackBar(
                                AppLocale.newName.getString(context), context);
                          } else {
                            savedProfileSearch.add(
                              SavedProfileSearch(
                                newName,
                                activeProfileSearch.copy(),
                              ),
                            );
                            databaseInsert('search', {
                              'user': profile.email,
                              'maxAge': activeProfileSearch.maxAge,
                              'minAge': activeProfileSearch.minAge,
                              'countries': activeProfileSearch.countries,
                              'skills': activeProfileSearch.skills,
                              'languages': activeProfileSearch.languages,
                              'genders': activeProfileSearch.genders,
                              'city': activeProfileSearch.city,
                              'name': newName,
                            });
                            Navigator.of(context).pop();
                          }
                        } else if (newName.isEmpty) {
                          showSnackBar(
                              AppLocale.newName.getString(context), context);
                        }
                      },
                    )
                  ],
                );
              },
            );
          }),
      SpeedDialChild(
          child: const Icon(Icons.cleaning_services),
          backgroundColor: rainbowColors[3],
          foregroundColor: Colors.white,
          label: AppLocale.clean.getString(context),
          onTap: () {
            setState(() {
              activeProfileSearch.clean();
              _currentRangeValues = RangeValues(18.toDouble(), 99.toDouble());
            });
          }),
    ];
    if (artificialIntelligenceEnabled) {
      res.addAll([
        SpeedDialChild(
          child: const Icon(Icons.sports_tennis),
          backgroundColor: rainbowColors[4],
          foregroundColor: Colors.white,
          label: AppLocale.suggestSkills.getString(context),
          onTap: () {
            for (String s
                in suggestFeature(profile.skills, 3, skills, skillSimilarity)) {
              if (!activeProfileSearch.skills.contains(s)) {
                activeProfileSearch.skills.add(s);
              }
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(conversations, searchIndex),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.abc),
          backgroundColor: rainbowColors[5],
          foregroundColor: Colors.white,
          label: AppLocale.suggestLanguages.getString(context),
          onTap: () {
            for (String s in suggestFeature(
                profile.languages, 3, languages, languageSimilarity)) {
              if (!activeProfileSearch.languages.contains(s)) {
                activeProfileSearch.languages.add(s);
              }
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(conversations, searchIndex),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.language),
          backgroundColor: rainbowColors[6],
          foregroundColor: Colors.white,
          label: AppLocale.suggestCountries.getString(context),
          onTap: () {
            for (String s in suggestFeature(
                [profile.country], 10, countries, countrySimilarity)) {
              if (!activeProfileSearch.countries.contains(s)) {
                activeProfileSearch.countries.add(s);
              }
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(conversations, searchIndex),
              ),
            );
          },
        ),
      ]);
    }
    return res;
  }

  List<Widget> showSavedSearches() {
    List<Widget> res = [];
    for (int i = 0; i < savedProfileSearch.length; i++) {
      res.add(ElevatedButton(
        onPressed: () {
          int min = activeProfileSearch.minAge ?? 18;
          int max = activeProfileSearch.maxAge ?? 99;
          setState(() {
            activeProfileSearch = savedProfileSearch[i].search.copy();
            _currentRangeValues = RangeValues(min.toDouble(), max.toDouble());
          });
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
          backgroundColor:
              MaterialStateProperty.all<Color>(rainbowColors[i % 7]),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        child: Text(savedProfileSearch[i].name),
      ));
    }
    return res;
  }
}
