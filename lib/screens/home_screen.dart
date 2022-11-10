import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/message.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/events/event_screen.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/screens/search/search_screen.dart';
import 'package:skillogue/utils/constants.dart';

class Home extends StatefulWidget {
  late List<Conversation> conversations;
  late Profile profile;
  late Search search;

  Home(this.profile, this.conversations, this.search);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  bool message = false;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();



  @override
  Widget build(BuildContext context) {
    if (widget.profile.logged == false) return MyApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      appName,
                      style: GoogleFonts.bebasNeue(
                          fontSize: 28, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 40,
                      child: Image.asset(
                        'assets/images/logo2.png',
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.profile.username,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: const [
            Icon(Icons.perm_identity, size: 30),
            Icon(Icons.event, size: 30),
            Icon(Icons.search, size: 30),
            Icon(Icons.message_outlined, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.black26,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: getScreen(),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black26),
    );
  }

  Widget getScreen() {
    switch (_page) {
      case searchIndex:
        {
          return SearchWidget(widget.profile, Search(), widget.conversations);
        }
      case profileIndex:
        {
          return WillPopScope(
            onWillPop: () async {
              print("willpop2");
              return true;
            },
            child: ProfileScreen(
                widget.profile, widget.conversations, widget.search),
          );
        }
      case messagesIndex:
        {
          updateConversations();
          return MessageWidget(widget.profile, widget.conversations);
        }
      case eventsIndex:
        {
          return EventWidget();
        }
      default:
        return Container();
    }
  }

  void updateConversations() async {
    print("UPDATING CONVERSATIONS AT ${DateTime.now()}");
    widget.conversations =
        await getConversationsFromMessages(widget.profile.username);
    sortConversations(widget.conversations);
  }
}
