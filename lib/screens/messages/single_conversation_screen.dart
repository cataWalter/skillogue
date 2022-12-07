import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/profile/profile_overview.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../home_screen.dart';

class SingleConversationScreen extends StatefulWidget {
  String destEmail;

  SingleConversationScreen(this.destEmail);

  @override
  State<SingleConversationScreen> createState() =>
      _SingleConversationScreenState();
}

class _SingleConversationScreenState extends State<SingleConversationScreen> {
  final newMessageController = TextEditingController();
  DateTime loginClickTime = DateTime.fromMicrosecondsSinceEpoch(0);
  late int curChatIndex;

  checkNewMessages() async {
    while (true) {
      setState(() {});
      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  void initState() {
    super.initState();
    curChatIndex = profileConversationIndex(conversations, widget.destEmail);
    checkNewMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
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
                await findProfileByEmail(conversations[curChatIndex].destEmail);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileOverview(lookupProfile),
              ),
            );
          },
          child: Text(
            conversations[curChatIndex].destName,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
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
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 0,
                child: Text(
                  newFunctionalityMessage,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupedListView(
                padding: const EdgeInsets.all(8),
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                elements: conversations[curChatIndex].messages,
                groupBy: (message) => DateTime(
                    message.date.year, message.date.month, message.date.day),
                groupHeaderBuilder: (message) => SizedBox(
                      height: 40,
                      child: Center(
                        child: Card(
                          color: Colors.blueGrey.withOpacity(0.7),
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
                            'receiver': conversations[curChatIndex].destEmail,
                            'text': newTextMessage,
                            'date': curDate.toString(),
                          });
                          conversations[curChatIndex].messages.add(
                              SingleMessage(0, newTextMessage, curDate, true));
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
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    parseTime(message.date),
                    style: TextStyle(fontSize: 10, color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    parseTime(message.date),
                    style: TextStyle(fontSize: 10, color: Colors.white),
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
