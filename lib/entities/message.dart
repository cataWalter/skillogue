import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/conversation.dart';

class Message {
  String sender;
  String receiver;
  String text;
  DateTime date;
  bool read;

  Message(this.sender, this.receiver, this.text, this.date, this.read);
}

Future<void> sendMessage(Message m) async {
  final message = ParseObject('Message')
    ..set('sender', m.sender)
    ..set('receiver', m.receiver)
    ..set('text', m.text)
    ..set('date', m.date);
  await message.save();
}

Future<List<Conversation>> getConversationsFromMessages(String username) async {
  List<Message> l = await queryAllMessages(username);
  List<Conversation> c = [];
  bool added;
  String newUsername;
  bool outgoing;
  for (Message x in l) {
    added = false;
    if (x.sender == username) {
      newUsername = x.receiver;
      outgoing = true;
    } else {
      newUsername = x.sender;
      outgoing = false;
    }
    for (Conversation y in c) {
      if (y.username == newUsername) {
        y.messages.add(SingleMessage(x.text, x.date, outgoing, x.read));
        added = true;
        break;
      }
    }
    if (added == false) {
      c.add(
          Conversation(newUsername, [SingleMessage(x.text, x.date, outgoing, x.read)]));
    }
  }
  return c;
}

Future<List<Message>> queryAllMessages(String username) async {
  List<Message> l1 = await queryMessages(username, 'sender');
  List<Message> l2 = await queryMessages(username, 'receiver');
  l1.addAll(l2);
  Comparator<Message> sortById = (a, b) => b.date.compareTo(a.date);
  l1.sort(sortById);
  return l1;
}

Future<List<Message>> queryMessages(String username, String role) async {
  List<ParseObject> results = <ParseObject>[];
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('Message'));
  parseQuery.whereEqualTo(role, username);
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  } else {
    results = [];
  }
  return messagesFromResults(results);
}

List<Message> messagesFromResults(List<ParseObject> results) {
  List<Message> newResults = <Message>[];
  for (var t in results) {
    newResults.add(messageFromJson(t));
  }
  return newResults;
}

Message messageFromJson(dynamic t) {
  return Message(
    t['sender'] as String,
    t['receiver'] as String,
    t['text'] as String,
    t['date'] as DateTime,
    t['read'] as bool
   );
}
