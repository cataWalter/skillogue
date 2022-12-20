import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/profile/profile_overview.dart';
import 'package:skillogue/utils/misc_functions.dart';

import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../home_screen.dart';

class SingleConversationScreen extends StatefulWidget {
  final Conversation conversation;

  const SingleConversationScreen(this.conversation, {super.key});

  @override
  State<SingleConversationScreen> createState() =>
      _SingleConversationScreenState();
}

class _SingleConversationScreenState extends State<SingleConversationScreen> {
  final newMessageController = TextEditingController();

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

  void nextScreenProfileOverview(lookupProfile) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileOverview(lookupProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
          onTap: () async {
            Profile lookupProfile =
                await findProfileByEmail(widget.conversation.destEmail);
            nextScreenProfileOverview(lookupProfile);
          },
          child: Row(
            children: [
              getAvatar(widget.conversation.destName, 20, 2),
              addHorizontalSpace(10),
              Text(
                widget.conversation.destName,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onSelected: (int item) async {
              switch (item) {
                case 0:
                  {
                    if (profile.blocked
                        .contains(widget.conversation.destEmail)) {
                      await supabase
                          .from('block')
                          .delete()
                          .eq('blocker', profile.email);
                      profile.blocked.remove(widget.conversation.destEmail);
                      setState(() {});
                    } else {
                      databaseInsert('block', {
                        'blocker': profile.email,
                        'blocked': widget.conversation.destEmail
                      });
                      profile.blocked.add(widget.conversation.destEmail);
                      setState(() {});
                    }
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              profile.blocked.contains(widget.conversation.destEmail)
                  ? const PopupMenuItem(
                      value: 0,
                      child: Text(
                        "Unblock",
                      ),
                    )
                  : const PopupMenuItem(
                      value: 0,
                      child: Text(
                        "Block",
                      ),
                    ),
            ],
          ),
        ],
      ),
      body: Container(
        /*decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.02, 0.9],
            colors: [
              Colors.blue,
              profile.color,
            ],
          ),
        ),*/
        color: profile.color,
        child: Column(
          children: [
            addVerticalSpace(10),
            Expanded(
              child: GroupedListView(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  elements: widget.conversation.messages,
                  groupBy: (message) => DateTime(
                      message.date.year, message.date.month, message.date.day),
                  groupHeaderBuilder: (message) => SizedBox(
                        height: 40,
                        child: Center(
                          child: Card(
                            color: Colors.black.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                parseDate(message.date),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                  itemBuilder: (context, message) {
                    return getSingleMessageWidget(message);
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.grey[300]),
                          controller: newMessageController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                            hintText: "Type a message...",
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          String newTextMessage =
                              newMessageController.text.trim();
                          if (newTextMessage.isNotEmpty) {
                            newMessageController.clear();
                            DateTime curDate = DateTime.now();
                            databaseInsert('message', {
                              'sender': profile.email,
                              'receiver': widget.conversation.destEmail,
                              'text': newTextMessage,
                              'date': curDate.toString(),
                            });
                            widget.conversation.messages.add(SingleMessage(
                                0, newTextMessage, curDate, true, false));
                            setState(() {});
                          }
                        },
                        child: const Icon(
                          Icons.send,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Align getSingleMessageWidget(SingleMessage message) {
    if (message.outgoing) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    parseTime(message.date),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    parseTime(message.date),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
