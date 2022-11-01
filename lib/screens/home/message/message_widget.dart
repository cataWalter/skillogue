import 'package:flutter/material.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/widgets/chat_card_widget.dart';

class MessageWidget extends StatefulWidget {
  Profile profile;
  List<Conversation> c;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();

  MessageWidget(this.profile, this.c, {super.key});
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.c.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.c.length,
        itemBuilder: ((context, index) =>
            ChatCard(widget.profile, widget.c[index])),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 80, left: 30, right: 30),
        child: Text(
          "No conversations here.\nStart making new friends now! :-)",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }
  }
}
