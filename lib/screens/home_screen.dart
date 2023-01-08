import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation_entity.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/entities/profile_search_entity.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/screens/profile/profile_settings_screen.dart';
import 'package:skillogue/screens/search/profile_search_screen.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/utils/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/message_entity.dart';
import '../utils/backend/message_backend.dart';
import '../utils/backend/misc_backend.dart';
import '../utils/backend/profile_search_backend.dart';
import '../utils/misc_functions.dart';
import 'authorization/pre_login_screen.dart';

List<Conversation> conversations = [];
Profile profile = Profile("email", "name", "country", "city", "gender", 99,
    DateTime.now(), ["languages"], ["skills"], 0);
ProfileSearch activeProfileSearch = ProfileSearch();
//late EventSearch activeEventSearch;
List<SavedProfileSearch> savedProfileSearch = [];
bool artificialIntelligenceEnabled = true;
Color chatColor = getRandomDarkColor();

class Home extends StatefulWidget {
  Home(conversations, this.currentPageIndex, {super.key});

  int currentPageIndex;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _myBox = Hive.box(localDatabase);
  TextEditingController newSuggestionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    artificialIntelligenceUpdate();
    conversationUpdate();
    findBlocked();
    savedSearchesUpdate();
    //initPlatformState();
    initColor();
  }

  initColor() {
    if (_myBox.get(chatColorKey) != null) {
      try {
        chatColor = Color(_myBox.get(chatColorKey));
      } catch (e) {
        _myBox.delete(chatColorKey);
      }
    } else {
      chatColor = getRandomDarkColor();
    }
  }

  artificialIntelligenceUpdate() {
    if (_myBox.get(artificialIntelligenceKey) != null) {
      try {
        artificialIntelligenceEnabled = _myBox.get(artificialIntelligenceKey);
      } catch (e) {
        _myBox.delete(artificialIntelligenceKey);
      }
    }
  }

  savedSearchesUpdate() async {
    savedProfileSearch = await getSavedSearches(profile.email);
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
              key: Key("c"),
              haptic: true,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              tabs: getButtons(),
              selectedIndex: widget.currentPageIndex,
              onTabChange: (index) {
                setState(() {
                  widget.currentPageIndex = index;
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
        text: AppLocale.profile.getString(context),
        iconColor: iconColor,
        textColor: textColor,
        hoverColor: hoverColor,
        iconActiveColor: iconActiveColor,
        key: Key("profileScreen"),
      ),
      GButton(
        icon: Icons.search,
        text: AppLocale.search.getString(context),
        iconColor: iconColor,
        textColor: textColor,
        hoverColor: hoverColor,
        iconActiveColor: iconActiveColor,
        key: Key("searchScreen"),
      ),
      GButton(
        icon: Icons.message,
        text: redNotification
            ? AppLocale.newMessages.getString(context)
            : AppLocale.chat.getString(context),
        iconColor: redNotification ? Colors.red : iconColor,
        textColor: redNotification ? Colors.red : textColor,
        hoverColor: hoverColor,
        iconActiveColor: redNotification ? Colors.red : iconActiveColor,
        key: Key("messageScreen"),

      ),
    ];
  }

  bool newMessages() {
    return conversations.isNotEmpty && !conversations[0].messages.last.outgoing;
  }

  getScreen() {
    switch (widget.currentPageIndex) {
      case searchIndex:
        {
          return const SearchScreen();
        }
      case profileIndex:
        {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                automaticallyImplyLeading: false,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      appName,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                actions: [
                  PopupMenuButton(
                    key: Key("PopupMenuButton"),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    onSelected: (int item) {
                      switch (item) {
                        case 0:
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileSettings(profile)));
                          }
                          break;
                        case 1:
                          {
                            newSuggestion(context, newSuggestionController);
                          }
                          break;
                        case 2:
                          {
                            getBlurDialog(
                                context,
                                AppLocale.acknowledgments.getString(context),
                                AppLocale.thanksAcknowledgments
                                    .getString(context));
                          }
                          break;
                        case 3:
                          {
                            signOut();
                            _myBox.delete(loggedProfileKey);
                            conversations = [];
                            activeProfileSearch.clean();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PreLogin()));
                          }
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        key: Key("pop0"),
                        value: 0,
                        child: Text(
                          AppLocale.settings.getString(context),
                        ),
                      ),
                      PopupMenuItem(
                        key: Key("pop1"),

                        value: 1,
                        child: Text(
                          AppLocale.contactUs.getString(context),
                        ),
                      ),
                      PopupMenuItem(
                        key: Key("pop2"),
                        value: 2,
                        child: Text(
                          AppLocale.acknowledgments.getString(context),
                        ),
                      ),
                      PopupMenuItem(
                        key: Key("pop3"),

                        value: 3,
                        child: Text(
                          AppLocale.logout.getString(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: ProfileScreen(profile, true));
        }
      case messagesIndex:
        {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                automaticallyImplyLeading: false,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appName,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          profile.name,
                          style: GoogleFonts.bebasNeue(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        addHorizontalSpace(10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: getAvatar(
                              profile.name, profile.points, 32, 1, 1, 8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: const MessageScreen());
        }
      /*case eventsIndex:
        {
          return const EventScreen();
        }*/
    }
  }

  signOut() async {
    await supabase.auth.signOut();
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
                DateTime.parse(payload.entries
                    .elementAt(4)
                    .value
                    .entries
                    .elementAt(0)
                    .value)));
        setState(() {});
        if (payload.entries.elementAt(4).value.entries.elementAt(3).value !=
            profile.email) {
          Profile destProfile = await findProfileByEmail(
              payload.entries.elementAt(4).value.entries.elementAt(3).value);
          newMessageNotification(
              destProfile.email,
              destProfile.name,
              destProfile.points,
              payload.entries.elementAt(4).value.entries.elementAt(4).value);
        }
      },
    ).subscribe();

    while (mounted) {
      conversations = await getNewMessages(profile.email, conversations);
      if (mounted) setState(() {});
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  static const String oneSignalAppId = "b56dbfe1-d278-47ff-a5aa-59a5b8cfd617";

  Future<void> initPlatformState() async {
    /*OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});*/
  }

  void newMessageNotification(email, name, points, message) {
    /*InAppNotifications.instance
      ..titleFontSize = 14.0
      ..descriptionFontSize = 11.0
      ..textColor = Colors.white
      ..backgroundColor = Colors.black
      ..shadow = true
      ..animationStyle = InAppNotificationsAnimationStyle.scale;*/
    /*InAppNotifications.show(
      title: "New message from " + name,
      leading: getAvatar(name, points, 50, 1, 1, 20),
      description: "\n" + message,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleConversationScreen(
                findConversation(email, conversations), true),
          ),
        );
      },
      persistent: false,
    );*/
  }
}
