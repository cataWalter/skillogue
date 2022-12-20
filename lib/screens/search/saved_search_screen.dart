import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/misc_functions.dart';

import '../../utils/backend/misc_backend.dart';

class SavedSearchScreen extends StatefulWidget {
  const SavedSearchScreen({Key? key}) : super(key: key);

  @override
  State<SavedSearchScreen> createState() => _SavedSearchScreenState();
}

class _SavedSearchScreenState extends State<SavedSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: getSearchResults());
  }

  Widget getSearchResults() {
    if (savedProfileSearch.isNotEmpty) {
      return ListView.builder(
        itemCount: savedProfileSearch.length,
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
                        setState(() {
                          activeProfileSearch =
                              savedProfileSearch[index].search.copy();
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(conversations, 1),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: AlertDialog(
                                title: const Text(
                                    "Do you want to delete this saved search?"),
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
                                      deleteDatabase(index);
                                      setState(() {
                                        savedProfileSearch
                                            .remove(savedProfileSearch[index]);
                                      });

                                      popScreen(context);
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      title: Text(
                        savedProfileSearch[index].name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Wrap(
                        runSpacing: -10,
                        spacing: 6,
                        children: singleTileCreator(savedProfileSearch[index]),
                      )),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "It's cold here! 🥶",
                style: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Save some searches and save time! :-)",
                style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
        ],
      );
    }
  }

  deleteDatabase(index) async {
    await supabase
        .from('search')
        .delete()
        .eq('user', profile.email)
        .eq('name', savedProfileSearch[index].name);
  }

  List<Chip> singleTileCreator(SavedProfileSearch x) {
    List<Chip> res = [];
    if (x.search.countries.isNotEmpty) {
      res.addAll(chippies(x.search.countries, 12));
    }
    if (x.search.skills.isNotEmpty) {
      res.addAll(chippies(x.search.skills, 12));
    }
    if (x.search.languages.isNotEmpty) {
      res.addAll(chippies(x.search.languages, 12));
    }
    if (x.search.genders.isNotEmpty) {
      res.addAll(chippies(
        x.search.genders,
        12,
      ));
    }
    if (x.search.city.isNotEmpty) {
      res.add(
        Chip(
          label: Text(
            x.search.city,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      );
    }
    if (x.search.maxAge != null && x.search.minAge != null) {
      res.add(
        Chip(
          label: Text(
            "${x.search.minAge} - ${x.search.maxAge}",
            style: const TextStyle(fontSize: 12),
          ),
        ),
      );
    }
    return res;
  }

  List<Chip> chippies(List<String> skills, double size) {
    List<Chip> res = [];
    Color c = getRandomDarkColor();
    for (String item in skills) {
      res.add(
        Chip(
          backgroundColor: c,
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
