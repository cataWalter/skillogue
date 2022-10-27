import 'package:flutter/material.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home/message/conversation_widget.dart';
import 'package:skillogue/utils/colors.dart';

class ChatCard extends StatelessWidget {


  Profile p;
  Conversation c;

  ChatCard(this.p, this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationWidget(c, p),
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
                c.username.toString()[0].toUpperCase() +
                    c.username.toString()[1].toUpperCase(),
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
                      c.username,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    getMessage(),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(
                parseDate(c.messages[0].date),
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMessage() {
    if (c.messages[0].outgoing == true) {
      return Row(
        children: [
          const Opacity(
            opacity: 0.64,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
          const Text("  "),
          getLastMessage(),
        ],
      );
    } else {
      return getLastMessage();
    }
  }

  Opacity getLastMessage() {
    if (c.messages[0].read == false && c.messages[0].outgoing == false) {
      return Opacity(
        opacity: 0.95,
        child: Text(
          c.messages[0].text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return Opacity(
        opacity: 0.64,
        child: Text(
          c.messages[0].text,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  String parseDate(DateTime d) {
    Duration difference = DateTime.now().difference(d);
    if (difference.inDays == 0) {
      return "${d.hour}:${d.minute}";
    }
    if (difference.inDays == 1) {
      return "yesterday";
    }
    return "${d.day}/${d.month}/${d.year}";
  }
}
