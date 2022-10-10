import 'package:flutter/material.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/bodies/home.dart';
import 'package:skillogue/widgets/bodies/search.dart';
import 'package:skillogue/widgets/bodies/message.dart';
import 'package:skillogue/widgets/bodies/profile.dart';
import 'package:skillogue/widgets/bodies/event.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreenHelper(),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }
}

class MainScreenHelper extends StatefulWidget {
  @override
  _MainScreenHelperState createState() => _MainScreenHelperState();
}

class _MainScreenHelperState extends State<MainScreenHelper> {
  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(47),
        child: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(APP_NAME),
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
      child: Container(
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
              style: TextStyle(fontSize: 10, color: Colors.white),
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
        return SearchWidget();
      case PROFILE:
        return ProfileWidget();
      case EVENTS:
        return EventWidget();
      case MESSAGES:
        return MessageWidget();
      default:
        return Container();
    }
  }
}
