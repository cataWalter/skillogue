import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
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

List<Conversation> conversations = [];
late Profile profile;

late ProfileSearch profileSearch;

class Home extends StatefulWidget {
  final Profile profile;
  final ProfileSearch profileSearch;

  const Home(conversations, this.profile, this.profileSearch, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final _myBox = Hive.box("mybox");

  @override
  void initState() {
    profile = widget.profile;
    profileSearch = widget.profileSearch;
    super.initState();
    conversationUpdate();
  }

  @override
  Widget build(BuildContext context) {
    _myBox.put(loggedProfileKey, profile.email);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: currentPageIndex == profileIndex
            ? ThisAppBar(profile.name, true)
            : ThisAppBar(profile.name, false),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: profileIndex,
        height: 50.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Colors.blue,
        items: navbarIcons(
          [
            Icons.perm_identity,
            //Icons.event,
            Icons.groups,
            Icons.message_outlined,
          ],
        ),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
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
    switch (currentPageIndex) {
      case searchIndex:
        {
          return const SearchScreen();
        }
      case profileIndex:
        {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: const ProfileScreen(),
          );
        }
      case messagesIndex:
        {
          return const MessageScreen();
        }
      /*case eventsIndex:
        {
          /*return EventScreen(
              widget.profile, widget.search, widget.conversations);*/
          return const Center(
              child: Text(
            newFunctionalityMessage,
          ));
        }*/
      default:
        return Container();
    }
  }

  conversationUpdate() async {
    supabase.channel('home_channel').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: '*'),
      (payload, [ref]) async {
        //print('Change received: ${payload.toString()}');
        conversations = await addMessage(
          payload.entries.elementAt(4).value.entries.elementAt(3).value ==
              profile.email,
          conversations,
          Message(
            payload.entries.elementAt(4).value.entries.elementAt(1).value,
            payload.entries.elementAt(4).value.entries.elementAt(3).value,
            payload.entries.elementAt(4).value.entries.elementAt(2).value,
            payload.entries.elementAt(4).value.entries.elementAt(4).value,
            DateTime.parse(
                payload.entries.elementAt(4).value.entries.elementAt(0).value),
            false,
          ),
        );
        setState(() {});
      },
    ).subscribe();

    while (mounted) {
      conversations = await getNewMessages(profile.email, conversations);
      setState(() {});
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}
