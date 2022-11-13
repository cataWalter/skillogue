import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:skillogue/screens/messages/conversation_screen.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';

class MessageScreen extends StatefulWidget {
  final Profile profile;
  final List<Conversation> allConversations;

  @override
  State<MessageScreen> createState() => _MessageScreenState();

  MessageScreen(this.profile, this.allConversations, {super.key});
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return getConversationScreen();
  }

  dynamic callback(){
    Future.delayed(Duration.zero, () async {
      setState(() {
      });
    });
  }


  Widget getConversationScreen() {
    if (widget.allConversations.isNotEmpty) {
      sortConversations(widget.allConversations);
      return ListView.builder(
        itemCount: widget.allConversations.length,
        itemBuilder: ((context, index) => chatCard(widget.profile,
            widget.allConversations[index], widget.allConversations)),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 60, left: 30, right: 30),
        child: Text(
          "No conversations here.\nStart making new friends now! :-)",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }
  }

  Widget chatCard(Profile pr1, Conversation co1, List<Conversation> al1) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(co1, pr1, al1, callback()),
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
                co1.username.toString()[0].toUpperCase() +
                    co1.username.toString()[1].toUpperCase(),
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
                      co1.username,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    addOutgoingIcon(
                      co1.messages.last.outgoing,
                      co1.messages.last.text.replaceAll("\n", " "),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(
                parseDateGroup(co1.messages.last.date),
                style: const TextStyle(color: Colors.white),
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
        style: TextStyle(color: Colors.white.withOpacity(0.6)),
        maxLines: 1,
      );
    } else {
      return AutoSizeText(
        t,
        overflow: TextOverflow.ellipsis,
        minFontSize: 14,
        style: TextStyle(color: Colors.white.withOpacity(0.2)),
        maxLines: 1,
      );
    }
  }


}


