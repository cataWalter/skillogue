import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/screens/search/profile_search_screen.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/message.dart';
import '../utils/backend/message_backend.dart';
import '../utils/backend/misc_backend.dart';
import 'events/event_screen.dart';

List<Conversation> conversations = [];
late Profile profile;
late ProfileSearch profileSearch;


class Home extends StatefulWidget {
  const Home(conversations, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  final _myBox = Hive.box(localDatabase);

  @override
  void initState() {
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            themeManager.isDarkNow()
                ? const BoxShadow(
                    blurRadius: 20,
                  )
                : BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              tabs: getButtons(),
              selectedIndex: currentPageIndex,
              onTabChange: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: getScreen(),
      ),
    );
  }

  List<GButton> getButtons() {
    if (themeManager.isDarkNow()) {
      return const [
        GButton(
          icon: Icons.person,
          text: 'Profile',
          iconColor: Colors.white,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
        GButton(
          icon: Icons.event,
          text: 'Events',
          iconColor: Colors.white,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
        GButton(
          icon: Icons.group,
          text: 'Friends',
          iconColor: Colors.white,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
        GButton(
          icon: Icons.message,
          text: 'Chat',
          iconColor: Colors.white,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
      ];
    } else {
      return const [
        GButton(
          icon: Icons.person,
          text: 'Profile',
          iconColor: Colors.black,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
        GButton(
          icon: Icons.event,
          text: 'Events',
          iconColor: Colors.black,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
        GButton(
          icon: Icons.group,
          text: 'Friends',
          iconColor: Colors.black,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
        GButton(
          icon: Icons.message,
          text: 'Chat',
          iconColor: Colors.black,
          textColor: Colors.black,
          hoverColor: Colors.white,
          iconActiveColor: Colors.black,
        ),
      ];
    }
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
      case eventsIndex:
        {
          return const EventScreen();
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
