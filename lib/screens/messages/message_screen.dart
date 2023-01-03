import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation_entity.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/utils/misc_functions.dart';
import 'package:skillogue/utils/responsive_layout.dart';

import '../../utils/localization.dart';
import '../home_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  State<MessageScreen> createState() => _MessageScreenState();

  const MessageScreen({super.key});
}

class _MessageScreenState extends State<MessageScreen> {
  int conversationIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (conversations.isNotEmpty) {
      conversations = sortConversations(conversations);
      return ResponsiveLayout(
        mobileBody: ListView.builder(
          itemCount: conversations.length,
          itemBuilder: ((context, index) =>
              mobileChatCard(conversations[index])),
        ),
        tabletBody: Row(
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: ((context, index) =>
                    tabletChatCard(conversations[index], index)),
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleConversationScreen(
                  conversations[conversationIndex], false),
            ),
          ],
        ),
        desktopBody: Row(
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: ((context, index) =>
                    tabletChatCard(conversations[index], index)),
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleConversationScreen(
                  conversations[conversationIndex], false),
            )
          ],
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.cold.getString(context),
                style: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    color: Theme
                        .of(context)
                        .brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.newFriends.getString(context),
                style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme
                        .of(context)
                        .brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
        ],
      );
    }
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

  Widget tabletChatCard(Conversation curConversation, int index) {
    return InkWell(
      onTap: () {
        setState(() {});
        profile.blockedBy.contains(curConversation.destEmail)
            ? getBlurDialogImage(
            context,
            AppLocale.sincere.getString(context) +
                curConversation.destName +
                AppLocale.blocked.getString(context),
            'assets/images/fuckAround.jpg',
            "${AppLocale.fuck.getString(context)}${curConversation.destName} ?")
            : setState(() {
          conversationIndex = index;
        });
      },
      highlightColor: Colors.blue.withOpacity(0.4),
      splashColor: Colors.green.withOpacity(0.5),
      child: index == conversationIndex
          ? Container(
        color: Colors.blue,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              getAvatar(curConversation.destName,
                  curConversation.destPoints, 24, 2, 1.4, 20),
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
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            getAvatar(curConversation.destName,
                curConversation.destPoints, 24, 2, 1.4, 20),
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

  Widget mobileChatCard(Conversation curConversation) {
    return InkWell(
      onTap: () {
        profile.blockedBy.contains(curConversation.destEmail)
            ? getBlurDialogImage(
            context,
            AppLocale.sincere.getString(context) +
                curConversation.destName +
                AppLocale.blocked.getString(context),
            'assets/images/fuckAround.jpg',
            "${AppLocale.fuck.getString(context)}${curConversation.destName} ?")
            : Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SingleConversationScreen(curConversation, true),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            getAvatar(curConversation.destName, curConversation.destPoints, 24,
                2, 1.4, 20),
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
