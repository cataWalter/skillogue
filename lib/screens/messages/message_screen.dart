import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/profile/profile_show.dart';

class MessageWidget extends StatefulWidget {
  final Profile profile;
  final List<Conversation> conversations;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();

  MessageWidget(this.profile, this.conversations, {super.key});
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return getConversationScreen();
  }

  Widget getConversationScreen() {
    if (widget.conversations.isNotEmpty) {
      sortConversations(widget.conversations);
      return ListView.builder(
        itemCount: widget.conversations.length,
        itemBuilder: ((context, index) =>
            ChatCard(widget.profile, widget.conversations[index], widget.conversations)),
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
}

class ChatCard extends StatelessWidget {
  Profile p;
  Conversation c;
  List<Conversation> allConv;

  ChatCard(this.p, this.c, this.allConv, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationWidget(c, p, allConv),
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
                    addOutgoingIcon(
                      c.messages.last.outgoing,
                      c.messages.last.text.replaceAll("\n", " "),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(
                parseDateGroup(c.messages.last.date),
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

String parseTime(DateTime d) {
  return "${parseSmallNumbers(d.hour)}:${parseSmallNumbers(d.minute)}";
}

String parseDate(DateTime d) {
  if (d.day == DateTime.now().day) {
    return "Today";
  }
  if (d.day == DateTime.now().day - 1) {
    return "Yesterday";
  }
  return '${parseSmallNumbers(d.day)}/${parseSmallNumbers(d.month)}/${d.year}';
}

String parseSmallNumbers(int n) {
  if (n <= 9) {
    return "0$n";
  } else {
    return n.toString();
  }
}

String parseDateGroup(DateTime d) {
  if (d.day == DateTime.now().day) {
    return parseTime(d);
  }
  if (d.day == DateTime.now().day - 1) {
    return "Yesterday";
  }
  return "${d.day}/${d.month}/${d.year}";
}

class ConversationWidget extends StatefulWidget {
  Conversation c;
  Profile p;
  List<Conversation> allConv;
  late Profile lookupProfile;

  ConversationWidget(this.c, this.p, this.allConv, {super.key});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  final newMessageController = TextEditingController();
  DateTime loginClickTime = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: GestureDetector(
            onTap: () async {
              widget.lookupProfile = await queryByUsername(widget.c.username);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          ProfileShow(widget.lookupProfile),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Text(widget.c.username),
          ),
          actions: [
            PopupMenuButton(
              color: myGrey,
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Text(
                    newFunctionalityMessage,
                    style: TextStyle(color: Colors.white),
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
                  elements: widget.c.messages,
                  groupBy: (message) => DateTime(
                      message.date.year, message.date.month, message.date.day),
                  groupHeaderBuilder: (message) => SizedBox(
                        height: 40,
                        child: Center(
                          child: Card(
                            color: Colors.grey.withOpacity(0.2),
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
            Container(
              color: Colors.green.withOpacity(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: myGrey,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: TextField(
                            controller: newMessageController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none),
                            style: TextStyle(color: Colors.grey[400]),
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
                            String t = newMessageController.text.trim();
                            if (t.isNotEmpty) {
                              newMessageController.clear();
                              final message = ParseObject('Message')
                                ..set('sender', widget.p.username)
                                ..set('receiver', widget.c.username)
                                ..set('text', t)
                                ..set('date', DateTime.now());
                              await message.save();
                              setState(() {
                                widget.c.messages.add(
                                    SingleMessage("", t, DateTime.now(), true));
                                sortConversations(widget.allConv);
                              });
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? myGrey = Colors.grey[900];

  Align getSingleMessageWidget(SingleMessage message) {
    if (message.outgoing) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(left: 60),
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
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10,
                    ),
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
            color: Colors.grey[900],
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
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10,
                    ),
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
