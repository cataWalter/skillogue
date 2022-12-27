import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_settings.dart';
import 'package:skillogue/screens/profile/profile_show.dart';
import 'package:skillogue/screens/profile/update_profile_info_screen.dart';
import 'package:skillogue/screens/search/profile_search_screen.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/utils/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/message.dart';
import '../utils/backend/message_backend.dart';
import '../utils/backend/misc_backend.dart';
import '../utils/backend/notifications.dart';
import '../utils/backend/profile_search_backend.dart';
import '../utils/misc_functions.dart';
import 'authorization/pre_login.dart';

List<Conversation> conversations = [];
late Profile profile;
ProfileSearch activeProfileSearch = ProfileSearch();
//late EventSearch activeEventSearch;
late List<SavedProfileSearch> savedProfileSearch;
bool artificialIntelligenceEnabled = false;

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
    pushNotifications();
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
      ),
      GButton(
        icon: Icons.search,
        text: AppLocale.search.getString(context),
        iconColor: iconColor,
        textColor: textColor,
        hoverColor: hoverColor,
        iconActiveColor: iconActiveColor,
      ),
      GButton(
        icon: Icons.message,
        text: redNotification
            ? countUnanswered().toString() +
                AppLocale.newMessages.getString(context)
            : AppLocale.chat.getString(context),
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

  getScreen() {
    switch (widget.currentPageIndex) {
      case searchIndex:
        {
          return SearchScreen();
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
                                      UpdateProfileInfoScreen(profile)),
                            );
                          }
                          break;
                        case 1:
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileSettings()));
                          }
                          break;
                        case 2:
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
                        case 3:
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AlertDialog(
                                    title: Text(AppLocale.suggestionTitle
                                        .getString(context)),
                                    content: TextField(
                                      controller: newSuggestionController,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      autocorrect: false,
                                      minLines: 1,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        fillColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? const Color.fromRGBO(
                                                    30, 30, 30, 1)
                                                : const Color.fromRGBO(
                                                    235, 235, 235, 1),
                                        hintText: AppLocale.whatSuggestion
                                            .getString(context),
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).hintColor),
                                        filled: true,
                                        suffixIcon: const Icon(Icons.message,
                                            color: Color.fromRGBO(
                                                129, 129, 129, 1)),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                            AppLocale.ok.getString(context)),
                                        onPressed: () {
                                          String newTextMessage =
                                              newSuggestionController.text
                                                  .trim();
                                          if (newTextMessage.isNotEmpty) {
                                            newSuggestionController.clear();
                                            DateTime curDate = DateTime.now();
                                            databaseInsert('suggestion', {
                                              'user': profile.email,
                                              'advice': newTextMessage,
                                              'date': curDate.toString(),
                                            });
                                            showSnackBar(
                                                AppLocale.thanks
                                                    .getString(context),
                                                context);
                                          }
                                          Navigator.of(context).pop();
                                          //showSnackBar("Thank you! 🥰", context);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          break;
                        case 4:
                          {
                            getBlurDialog(
                                context,
                                AppLocale.acknowledgments.getString(context),
                                AppLocale.thanksAcknowledgments
                                    .getString(context));
                          }
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Text(
                          AppLocale.updateProfile.getString(context),
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          AppLocale.settings.getString(context),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          AppLocale.contactUs.getString(context),
                        ),
                      ),
                      PopupMenuItem(
                        value: 4,
                        child: Text(
                          AppLocale.acknowledgments.getString(context),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          AppLocale.logout.getString(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: ProfileShow(profile, true));
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
        conversations = await addMessage12345(
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

  void pushNotifications() {
    Notifications().addNotification(
      'New messages',
      'You have ${countUnanswered()} unread messages',
      DateTime.now().millisecondsSinceEpoch + 1000,
      channel: 'testing',
    );
  }
}
