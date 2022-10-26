import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/screens/home/message/menu.dart';

class ConversationWidget extends StatefulWidget {
  Conversation c;

  ConversationWidget(this.c, {super.key});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  @override
  Widget build(BuildContext context) {
    final newMessageController = TextEditingController();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Chat"),
          actions: [
            PopupMenuButton(
              color: myGrey,
              onSelected: (Menu item) {
                print(item.name);
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: Menu.itemOne,
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
                                parseDateGroupbuilder(message.date),
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
                            style: TextStyle(
                                color: Colors.grey[400]), //<-- SEE HERE
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
                          onPressed: () {
                            setState(() {
                              widget.c.messages.add(SingleMessage(
                                  newMessageController.text,
                                  DateTime.now(),
                                  true,
                                  false));
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

  String parseDateGroupbuilder(DateTime d) {
    Duration difference = DateTime.now().difference(d);
    if (difference.inDays == 0) {
      return "Today";
    }
    if (difference.inDays == 1) {
      return "Yesterday";
    }
    return "${d.day}/${d.month}/${d.year}";
  }

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
                    "${message.date.hour}:${message.date.minute}",
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
                    "${message.date.hour}:${message.date.minute}",
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

  @override
  void initState() {
    super.initState();
    for (SingleMessage x in widget.c.messages) {
      x.read = true;
    }
  }
}
