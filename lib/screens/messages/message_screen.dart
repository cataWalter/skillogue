import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../entities/message.dart';
import '../../utils/backend/message_backend.dart';
import '../../utils/backend/misc_backend.dart';
import '../../utils/colors.dart';
import '../home_screen.dart';

class MessageScreen extends StatefulWidget {
  final Profile profile;

  //List<Conversation> c;
  @override
  State<MessageScreen> createState() => _MessageScreenState();

  MessageScreen(this.profile, {super.key});
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return getConversationScreen();
  }



  cleanEmptyConversations() {
    conversations.removeWhere((x) => x.messages.isEmpty);
  }

  checkNewMessages() async {
    while (true) {
      if (newAvailableMessages) {
        print("updated messages in message screen");
        setState(() {});
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void initState() {
    super.initState();
    cleanEmptyConversations();
    checkNewMessages();
  }

  Widget getConversationScreen() {
    if (conversations.isNotEmpty) {
      List<Conversation> c1 = conversations;
      conversations = sortConversations(conversations);
      return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: ((context, index) =>
            chatCard(widget.profile, conversations[index])),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
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
            builder: (context) => SingleConversationScreen(
                curConversation.destEmail, curProfile),
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
                style: TextStyle(
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
                      style: TextStyle(
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
                style: TextStyle(),
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
