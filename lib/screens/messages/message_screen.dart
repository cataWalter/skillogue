import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/utils/misc_functions.dart';

import '../home_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  State<MessageScreen> createState() => _MessageScreenState();

  const MessageScreen({super.key});
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return getConversationScreen();
  }

  checkNewMessages() async {
    while (mounted) {
      setState(() {});
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void initState() {
    super.initState();
    checkNewMessages();
  }

  Widget getConversationScreen() {
    if (conversations.isNotEmpty) {
      conversations = sortConversations(conversations);
      return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: ((context, index) => chatCard(conversations[index])),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "It's cold here! 🥶",
                style: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Start making new friends now! :-)",
                style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget chatCard(Conversation curConversation) {
    return InkWell(
      onTap: () {
        profile.blockedBy.contains(curConversation.destEmail)
            ? getBlurDialogImage(
                context,
                "We want to be sincere. ${curConversation.destName} blocked you. We are sorry for the inconvenience but no worries, luckily the world is big! 🙊",
                'assets/images/fuckAround.jpg',
                "Fuck ${curConversation.destName} ?")
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SingleConversationScreen(curConversation),
                ),
              );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            getAvatar(
                curConversation.destName, curConversation.destColor, 24, 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      curConversation.destName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    addVerticalSpace(8),
                    getOverflowReplacement(
                        curConversation.messages.last.text
                            .replaceAll("\n", " "),
                        curConversation.messages.last.outgoing),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(
                parseDateGroup(curConversation.messages.last.date),
              ),
            )
          ],
        ),
      ),
    );
  }

  AutoSizeText getOverflowReplacement(String t, bool normal) {
    if (normal) {
      return AutoSizeText(
        t,
        overflow: TextOverflow.ellipsis,
        minFontSize: 14,
        maxLines: 1,
      );
    } else {
      return AutoSizeText(
        t,
        style: const TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        minFontSize: 14,
        maxLines: 1,
      );
    }
  }
}
