import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_show.dart';
import 'package:skillogue/screens/search/profile_search_screen.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/message.dart';
import '../utils/backend/message_backend.dart';
import '../utils/backend/misc_backend.dart';

List<Conversation> conversations = [];
late Profile profile;
ProfileSearch activeProfileSearch = ProfileSearch();
//late EventSearch activeEventSearch;
List<SavedProfileSearch> savedProfileSearch = [];

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
    findBlocked();
  }

  findBlocked() async {
    profile.blocked = await getBlocked(profile.email);
    profile.blockedBy = await getBlockedBy(profile.email);
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
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
      body: getScreen(),
    );
  }

  List<GButton> getButtons() {
    Color iconColor;
    Color textColor;
    Color hoverColor;
    Color iconActiveColor;
    bool redNotification = newMessages();
    if (themeManager.isDarkNow()) {
      iconColor = Colors.white;
      textColor = Colors.black;
      hoverColor = Colors.white;
      iconActiveColor = Colors.black;
    } else {
      iconColor = Colors.black;
      textColor = Colors.black;
      hoverColor = Colors.black;
      iconActiveColor = Colors.black;
    }
    return [
      GButton(
        icon: Icons.person,
        text: 'Profile',
        iconColor: iconColor,
        textColor: textColor,
        hoverColor: hoverColor,
        iconActiveColor: iconActiveColor,
      ),
      GButton(
        icon: Icons.search,
        text: 'Search',
        iconColor: iconColor,
        textColor: textColor,
        hoverColor: hoverColor,
        iconActiveColor: iconActiveColor,
      ),
      GButton(
        icon: Icons.message,
        text: redNotification ? '${countUnanswered()} new messages' : 'Chat',
        iconColor: redNotification ? Colors.red : iconColor,
        textColor: redNotification ? Colors.red : textColor,
        hoverColor: hoverColor,
        iconActiveColor: redNotification ? Colors.red : iconActiveColor,
      ),
    ];
  }

  int countUnanswered() {
    int index = 0;
    for (; index < conversations.length; index++) {
      if (conversations[index].messages.last.outgoing) {
        return index;
      }
    }
    return index;
  }

  bool newMessages() {
    return conversations.isNotEmpty && !conversations[0].messages.last.outgoing;
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
            child: ProfileShow(profile, true),
          );
        }
      case messagesIndex:
        {
          return const MessageScreen();
        }
      /*case eventsIndex:
        {
          return const EventScreen();
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
          ),
        );
        setState(() {});
      },
    ).subscribe();

    while (mounted) {
      conversations = await getNewMessages(profile.email, conversations);
      if (mounted) setState(() {});
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}
