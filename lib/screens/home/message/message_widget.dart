import 'package:flutter/material.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home/message/chat_card_widget.dart';

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
    return ListView.builder(
      itemCount: widget.c.length,
      itemBuilder: ((context, index) => ChatCard(widget.profile, widget.c[index])),
    );
  }
}
