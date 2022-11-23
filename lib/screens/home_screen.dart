import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/message.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/events/event_screen.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/screens/search/search_screen.dart';
import 'package:skillogue/utils/constants.dart';

class Home extends StatefulWidget {
  late List<Conversation> conversations;
  late Profile profile;
  late ProfileSearch search;

  Home(this.profile, this.conversations, this.search, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.profile.logged == false) return const MyApp();
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
          updateConversations();
          return MessageScreen(widget.profile, widget.conversations);
        }
      case eventsIndex:
        {
          /*return EventScreen(
              widget.profile, widget.search, widget.conversations);*/
          return const Center(child: Text(newFunctionalityMessage, style: TextStyle(color: Colors.white),));
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
