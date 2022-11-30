import 'dart:collection';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/screens/search/search_screen.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/backend/message_backend.dart';

class Home extends StatefulWidget {
  List<Conversation> conversations;
  final Profile profile;
  final ProfileSearch search;

  Home(this.conversations, this.profile, this.search, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final _myBox = Hive.box("mybox");

  @override
  void initState() {
    super.initState();
    updateConversations();
  }

  updateConversations() {
    supabase.channel('*').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: '*'),
      (payload, [ref]) {
        parsePayload(payload);
        setState(() {});
      },
    ).subscribe();
  }

  parsePayload(LinkedHashMap payload) async {
    String eventType = payload.entries.elementAt(3).value;
    if (eventType == "INSERT") {
      DateTime date = DateTime.parse(
          payload.entries.elementAt(4).value.entries.elementAt(0).value);
      int id = payload.entries.elementAt(4).value.entries.elementAt(1).value;
      String receiverEmail =
          payload.entries.elementAt(4).value.entries.elementAt(2).value;
      String senderEmail =
          payload.entries.elementAt(4).value.entries.elementAt(3).value;
      String text =
          payload.entries.elementAt(4).value.entries.elementAt(4).value;
      for (Conversation c in widget.conversations) {
        if (c.destEmail == senderEmail) {
          c.messages.add(SingleMessage(id, text, date, false));
          return;
        }
      }
      widget.conversations.add(Conversation(senderEmail,
          await findName(senderEmail), [SingleMessage(id, text, date, false)]));
    }
    /*else if (eventType == "DELETE") {
      int oldId = payload.entries.elementAt(5).value.entries.elementAt(0).value;
      for (Conversation c in widget.conversations) {
        for (SingleMessage m in c.messages) {
          if (m.id == oldId) {
            c.messages.remove(m);
            return;
          }
        }
      }
    } */
  }

  @override
  Widget build(BuildContext context) {
    _myBox.put(loggedProfileKey, widget.profile.email);
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
                  widget.profile.name,
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
            Icon(
              Icons.perm_identity,
              size: 30,
            ),
            Icon(
              Icons.event,
              size: 30,
            ),
            Icon(
              Icons.groups,
              size: 30,
            ),
            Icon(
              Icons.message_outlined,
              size: 30,
            ),
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
          padding: const EdgeInsets.only(bottom: 20.0),
          child: getScreen(),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }

  Widget getScreen() {
    switch (_page) {
      case searchIndex:
        {
          return SearchScreen(
              widget.profile, widget.search, widget.conversations);
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
          return MessageScreen(widget.profile, widget.conversations);
        }
      case eventsIndex:
        {
          /*return EventScreen(
              widget.profile, widget.search, widget.conversations);*/
          return const Center(
              child: Text(
            newFunctionalityMessage,
            style: TextStyle(color: Colors.white),
          ));
        }
      default:
        return Container();
    }
  }
}
