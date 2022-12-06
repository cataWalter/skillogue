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

late List<Conversation> conversations = [];
bool newAvailableMessages = false;

class Home extends StatefulWidget {
  final Profile profile;
  final ProfileSearch search;
  late List<Conversation> c;

  Home(this.c, this.profile, this.search, {super.key});

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
    conversationUpdate();
  }

  @override
  Widget build(BuildContext context) {
    conversations = widget.c;
    /*
    supabase.channel('a').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: '*'),
      (payload, [ref]) {
        print('Change received: ${payload.toString()}');
        parsePayload(payload, widget.profile.email, conversations);
      },
    ).subscribe();*/
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
          return SearchScreen(widget.profile, widget.search, conversations);
        }
      case profileIndex:
        {
          return WillPopScope(
            onWillPop: () async {
              print("willpop2");
              return true;
            },
            child: ProfileScreen(widget.profile, conversations, widget.search),
          );
        }
      case messagesIndex:
        {
          return MessageScreen(widget.profile);
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

  conversationUpdate() async {
    supabase.channel('home_channel').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: '*'),
      (payload, [ref]) async {
        print('Change received: ${payload.toString()}');
        conversations = await addMessage(
          payload.entries.elementAt(4).value.entries.elementAt(3).value ==
              widget.profile.email,
          conversations,
          Message(
            payload.entries.elementAt(4).value.entries.elementAt(1).value,
            payload.entries.elementAt(4).value.entries.elementAt(3).value,
            payload.entries.elementAt(4).value.entries.elementAt(2).value,
            payload.entries.elementAt(4).value.entries.elementAt(4).value,
            DateTime.parse(
                payload.entries.elementAt(4).value.entries.elementAt(0).value),
          ),
        );
        setState(() {});
      },
    ).subscribe();
    while (true) {
      conversations = await getNewMessages(widget.profile.email, conversations);
      setState(() {});
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}
