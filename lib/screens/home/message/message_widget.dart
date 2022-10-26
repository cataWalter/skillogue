import 'package:flutter/material.dart';
import 'package:skillogue/entities/chatCard_widget.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';

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
      itemBuilder: ((context, index) => ChatCard(
            c: widget.c[index],
          )),
    );
  }
}
