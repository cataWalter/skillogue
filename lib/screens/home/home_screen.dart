import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/message.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search.dart';
import 'package:skillogue/screens/home/message_screen.dart';
import 'package:skillogue/screens/home/profile_screen.dart';
import 'package:skillogue/screens/home/search_screen.dart';
import 'package:skillogue/utils/constants.dart';

class Home extends StatelessWidget {
  Profile profile;
  int currentPage;

  Home(this.profile, this.currentPage, {super.key});

  @override
  Widget build(BuildContext context) {
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

  @override
  void initState() {
    super.initState();

    updateConversations();
    sleep(const Duration(seconds: 1));
  }

  void updateConversations() async {
    c = await getConversationsFromMessages(widget.profile.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: Container(
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
            buildNavBarItem(Icons.person, PROFILE, "Profile"),
            //buildNavBarItem(Icons.event, EVENTS, "Events"),
            //buildNavBarItem(Icons.home, HOME, "Home"),
            buildNavBarItem(Icons.search, SEARCH, "Search"),
            buildMessageItem(),
            // buildNavBarItem(Icons.messenger_outlined, MESSAGES, "Messages"),
          ],
        ),
      ),
    );
  }

  Widget buildMessageItem(){
    bool _finalRead = true;

    setState(() {
      for (Conversation conv in c){
        SingleMessage m = conv.messages.last;
        _finalRead = (_finalRead && m.read);
        }
      });
    return _finalRead ? buildNavBarItem(Icons.mark_chat_unread, MESSAGES, "Messages") : buildNavBarItem(Icons.chat_bubble, MESSAGES, "Messages");
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
          updateConversations();
          return SearchWidget(widget.profile, widget.search, c);
        }
      case PROFILE:
        {
          updateConversations();
          return ProfileScreen(widget.profile);
        }
      case MESSAGES:
        {
          updateConversations();
          return MessageWidget(widget.profile, c);
        }
      default:
        return Container();
    }
  }
}
