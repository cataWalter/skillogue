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
import 'package:skillogue/utils/appbar.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/message.dart';
import '../utils/backend/message_backend.dart';
import '../utils/backend/misc_backend.dart';
import '../utils/colors.dart';

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
      widget.conversations = await addMessage(
        payload.entries.elementAt(4).value.entries.elementAt(3).value ==
            widget.profile.email,
        widget.conversations,
        Message(
          payload.entries.elementAt(4).value.entries.elementAt(1).value,
          payload.entries.elementAt(4).value.entries.elementAt(3).value,
          payload.entries.elementAt(4).value.entries.elementAt(2).value,
          payload.entries.elementAt(4).value.entries.elementAt(4).value,
          DateTime.parse(
              payload.entries.elementAt(4).value.entries.elementAt(0).value),
        ),
      );
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: myAppbar(widget.profile.name),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Colors.blue,
        items: navbarIcons(
          [
            Icons.perm_identity,
            Icons.event,
            Icons.groups,
            Icons.message_outlined,
          ],
        ),
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
    );
  }

  List<Icon> navbarIcons(List<IconData> icons) {
    List<Icon> res = [];
    for (var singleIcon in icons) {
      res.add(
        Icon(
          singleIcon,
          size: 30,
          color: Colors.white,
        ),
      );
    }
    return res;
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
          ));
        }
      default:
        return Container();
    }
  }
}
