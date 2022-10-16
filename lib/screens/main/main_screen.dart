import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search_entity.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/home.dart';
import 'package:skillogue/widgets/search.dart';
import 'package:skillogue/widgets/message.dart';
import 'package:skillogue/widgets/profile_widget.dart';
import 'package:skillogue/widgets/event.dart';

class MainScreen extends StatelessWidget {
  Profile profile;

  MainScreen(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreenHelper(profile),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }
}

class MainScreenHelper extends StatefulWidget {
  Profile profile;
  Search search = Search();

  MainScreenHelper(this.profile, {super.key});

  @override
  _MainScreenHelperState createState() => _MainScreenHelperState();
}

class _MainScreenHelperState extends State<MainScreenHelper> {
  int _selectedItemIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.search = Search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    APP_NAME,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 40,
                    child: Image.asset(
                      'assets/images/logo - reduced.png',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  /*
                  Text(
                  "Welcome back                ",
                  style: GoogleFonts.bebasNeue(fontSize: 14),
                ),
                */
                  Text(
                    widget.profile.username,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: getScreen(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
              )
            ],
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem(Icons.person, PROFILE, "Profile"),
            //buildNavBarItem(Icons.event, EVENTS, "Events"),
            buildNavBarItem(Icons.home, HOME, "Home"),
            buildNavBarItem(Icons.search, SEARCH, "Search"),
            buildNavBarItem(Icons.messenger_outlined, MESSAGES, "Messages"),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: 45,
        child: Column(
          children: [
            Icon(
              icon,
              size: 25,
              color:
                  index == _selectedItemIndex ? Colors.black : Colors.grey[700],
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget getScreen() {
    switch (_selectedItemIndex) {
      case HOME:
        return HomeWidget();
      case SEARCH:
        return SearchWidget(widget.profile, widget.search);
      case PROFILE:
        return const ProfileScreen();
      case EVENTS:
        return const EventWidget();
      case MESSAGES:
        return const MessageWidget();
      default:
        return Container();
    }
  }
}
