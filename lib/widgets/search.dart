import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search_entity.dart';
import 'package:skillogue/widgets/dialog_box.dart';

class SearchWidget extends StatefulWidget {
  Profile curProfile;
  Search curSearch;

  SearchWidget(this.curProfile, this.curSearch, {super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _searchResults = false;
  final controllerCity = TextEditingController();
  final controllerPassword = TextEditingController();

  //final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSearch(),
    );
  }

  Widget getSearch() {
    if (_searchResults == false) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: putDialog,
                      child: const Text(
                        'Skills',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Languages',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Countries',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 300,
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
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.teal.shade300,
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
                      onPressed: () => {
                        setState(() {
                          _searchResults = true;
                        })
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(); //results
    }
  }

  void putDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(widget.curSearch);
      },
    );
  }

  List<Profile> doUserSearch() {
    List<Profile> results = [];
    return results;
  }
}
