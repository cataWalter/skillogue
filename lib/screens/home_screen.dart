import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/message.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/screens/search/search_screen.dart';

import 'package:skillogue/constants.dart';

class Home extends StatelessWidget {
  Profile profile;
  int currentPage = searchIndex;

  Home(this.profile, this.currentPage, {super.key});

  @override
  Widget build(BuildContext context) {
    if (profile.logged == false) return MyApp();
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(profile, currentPage),
          ),
        );
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeHelper(profile, currentPage),
        theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      ),
    );
  }
}

class HomeHelper extends StatefulWidget {
  Profile profile;
  Search search = Search();
  int currentPage;

  HomeHelper(this.profile, this.currentPage, {super.key});

  @override
  _HomeHelperState createState() => _HomeHelperState();
}

class _HomeHelperState extends State<HomeHelper> {
  List<Conversation> c = [];
  bool newMessages = false;

  @override
  void initState() {
    super.initState();
    //repeatUpdateConversations();
  }

  void repeatUpdateConversations() async {
    while (true) {
      updateConversations();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void updateConversations() async {
    bool foundNewMessage = false;
    c = await getConversationsFromMessages(widget.profile.username);
    sortConversations(c);
    for (Conversation x in c) {
      if (x.messages.last.outgoing == false && x.messages.last.read == false) {
        setState(() {
          newMessages = true;
          foundNewMessage = true;
        });
        break;
      }
    }
    if (foundNewMessage == false) {
      setState(() {
        newMessages = false;
      });
    }
  }

  void sortConversations(List<Conversation> c) {
    Comparator<Conversation> sortById =
        (a, b) => a.messages.last.date.compareTo(b.messages.last.date);
    c.sort(sortById);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: widget.currentPage == messagesIndex
          ? SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                onPressed: updateConversations,
                backgroundColor: Colors.black,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                    Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 8,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
                    APP_NAME,
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
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: getScreen(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                )
              ],
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavBarItem(Icons.person, profileIndex, "Profile"),
              //buildNavBarItem(Icons.event, EVENTS, "Events"),
              //buildNavBarItem(Icons.home, HOME, "Home"),
              buildNavBarItem(Icons.search, searchIndex, "Search"),
              newMessages
                  ? buildMessageItem(messagesIndex, "Messages")
                  : buildNavBarItem(
                      Icons.chat_bubble, messagesIndex, "Messages"),
              // buildNavBarItem(Icons.messenger_outlined, MESSAGES, "Messages"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageItem(int index, String text) {
    double radius = MediaQuery.of(context).size.width / 5;
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.currentPage = index;
        });
      },
      child: SizedBox(
        width: radius,
        height: 45,
        child: Column(
            children: [
              SizedBox(
                child: Stack(
                  children: [
                    Icon(
                        Icons.chat_bubble,
                        size: 30,
                        color: index == widget.currentPage ? Colors.black : Colors.grey[600],
                      ),
                    Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 5,
                      textDirection: TextDirection.ltr,


                    ),
                  ],
                ),
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
        ),
      ),
    );
  }


  Widget buildNavBarItem(IconData icon, int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.currentPage = index;
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: 45,
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color:
                  index == widget.currentPage ? Colors.black : Colors.grey[600],
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget getScreen() {
    switch (widget.currentPage) {
      case SEARCH:
        {
          return SearchWidget(widget.profile, widget.search, c);
        }
      case PROFILE:
        {
          return ProfileScreen(widget.profile);
        }
      case MESSAGES:
        {
          return MessageWidget(widget.profile, c);
        }
      default:
        return Container();
    }
  }
}
