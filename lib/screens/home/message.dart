import 'package:flutter/material.dart';
import 'package:skillogue/entities/message.dart';
/*
class MessageWidget extends StatefulWidget {
  const MessageWidget({Key? key}) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  List<Message> messages = [
    Message(
        user: 'Antonio',
        last_message: 'can you on saturday',
        date_last_message: DateTime.now()),
    Message(
        user: 'Carmen',
        last_message: 'I want to learn your skill',
        date_last_message: DateTime.now()),
    Message(
        user: 'Diego',
        last_message: 'What skill do you have',
        date_last_message: DateTime.now()),
  ];

  Widget messageTemplate(message) {
    return GestureDetector(
        onTap: () {
          setState(() {
            print('well done');
          });
        },
        child: Card(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            color: Colors.blueGrey[400],
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      message.user,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          message.last_message,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          message.date_last_message.hour.toString() + ' h',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('message'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: messages.map((message) => messageTemplate(message)).toList(),
      ),
    );
  }
}
*/