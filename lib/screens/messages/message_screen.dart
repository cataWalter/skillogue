import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/constants.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/message.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/profile/profile_show.dart';

class MessageWidget extends StatefulWidget {
  Profile p;
  List<Conversation> c;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();

  MessageWidget(this.p, this.c, {super.key});
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return getConversationScreen();
  }

  Widget getConversationScreen() {
    if (widget.c.isNotEmpty) {
      sortConversations(widget.c);
      return ListView.builder(
        itemCount: widget.c.length,
        itemBuilder: ((context, index) =>
            ChatCard(widget.p, widget.c[index], widget.c)),
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
        for (var x in c.messages) {
          if (x.outgoing == false && x.read == false) {
            x.read = true;
          }
        }
        setRead(c.username, p.username);
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
                    getMessage(),
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
    if (c.messages.last.read == false && c.messages.last.outgoing == false) {
      return Opacity(
        opacity: 0.95,
        child: Text(
          c.messages.last.text,
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
          c.messages.last.text,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
  @override
  Widget build(BuildContext context) {
    final newMessageController = TextEditingController();
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
                    body: Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        ProfileShow(widget.lookupProfile),
                      ],
                    ),
                    /*
                    bottomNavigationBar: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.abc_outlined,
                          color: Colors.white,
                          size: 100,
                        ),
                      ],
                    ),
                    */
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
                    'Coming soon...',
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
                          onPressed: () async {
                            final message = ParseObject('Message')
                              ..set('sender', widget.p.username)
                              ..set('receiver', widget.c.username)
                              ..set('text', newMessageController.text.trim())
                              ..set('date', DateTime.now())
                              ..set('read', false);
                            await message.save();
                            setState(() {
                              widget.c.messages.add(SingleMessage(
                                  "",
                                  newMessageController.text.trim(),
                                  DateTime.now(),
                                  true,
                                  false));
                              sortConversations(widget.allConv);
                            });
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
