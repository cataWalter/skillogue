import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';

import '../../utils/colors.dart';
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
        itemBuilder: ((context, index) =>
            chatCard(profile, conversations[index])),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Text(
          "No conversations here.\nStart making new friends now! :-)",
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }

  Widget chatCard(Profile curProfile, Conversation curConversation) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SingleConversationScreen(curConversation.destEmail),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: getRandomDarkColor(),
              child: Text(
                curConversation.destName.toString()[0].toUpperCase() +
                    curConversation.destName.toString()[1].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
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
                    const SizedBox(height: 8),
                    addOutgoingIcon(
                      curConversation.messages.last.outgoing,
                      curConversation.messages.last.text.replaceAll("\n", " "),
                    ),
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

  addOutgoingIcon(bool outgoing, String t) {
    if (!outgoing) {
      return getOverflowReplacement(t, true);
    } else {
      return getOverflowReplacement(t, false);
    }
  }

  AutoSizeText getOverflowReplacement(String t, bool bold) {
    if (bold) {
      return AutoSizeText(
        t,
        overflow: TextOverflow.ellipsis,
        minFontSize: 14,
        maxLines: 1,
      );
    } else {
      return AutoSizeText(
        t,
        overflow: TextOverflow.ellipsis,
        minFontSize: 14,
        maxLines: 1,
      );
    }
  }
}
