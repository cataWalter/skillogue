import 'dart:collection';
import 'dart:io';

import '../../entities/conversation.dart';
import '../../entities/message.dart';
import 'misc_backend.dart';

Future<String> findName(String email) async {
  return (await supabase.from('profile').select('name').eq('email', email))[0]
      .values
      .first;
}

Future<void> sendMessage(String source, String dest, String text) async {
  databaseInsert('message', {
    'sender': source,
    'receiver': dest,
    'text': text,
    'date' : DateTime.now().toString(),
  });
}

Future<List<Conversation>> getMessagesAll(String email) async {
  List<Conversation> newConversations = [];
  final List<dynamic> sentMessages =
      await supabase.from('message').select().eq('sender', email);
  final List<dynamic> receivedMessages =
      await supabase.from('message').select().eq('receiver', email);
  for (LinkedHashMap x in sentMessages) {
    newConversations =
        await addMessage(true, newConversations, await parseMessage(x));
  }
  for (LinkedHashMap x in receivedMessages) {
    newConversations =
        await addMessage(false, newConversations, await parseMessage(x));
  }
  sortConversations(newConversations);
  return newConversations;
}

Future<Message> parseMessage(LinkedHashMap x) async {
  return Message(
    x.entries.elementAt(0).value,
    x.entries.elementAt(3).value,
    x.entries.elementAt(4).value,
    x.entries.elementAt(2).value,
    DateTime.parse(x.entries.elementAt(1).value),
  );
}

bool existsMessage(Message m, List<Conversation> conversations) {
  for (Conversation c in conversations) {
    for (SingleMessage x in c.messages) {
      if (m.id == x.id) {
        return true;
      } else if (x.date.isAtSameMomentAs(m.date)) {
        x.id = m.id;
        return true;
      }
    }
  }

  return false;
}

Future<List<Conversation>> addMessage(
    bool outgoing, List<Conversation> conversations, Message m) async {
  if (existsMessage(m, conversations)) {
    return conversations;
  }
  bool added = false;
  if (outgoing) {
    for (Conversation c in conversations) {
      if (c.destEmail == m.receiverEmail) {
        added = true;
        c.messages.add(SingleMessage(m.id, m.text, m.date, true));
        return conversations;
      }
    }
    if (added == false) {
      conversations.add(Conversation(
          m.receiverEmail,
          await findName(m.receiverEmail),
          [SingleMessage(m.id, m.text, m.date, true)]));
      return conversations;
    }
  } else {
    for (Conversation c in conversations) {
      if (c.destEmail == m.senderEmail) {
        added = true;
        c.messages.add(SingleMessage(m.id, m.text, m.date, false));
        return conversations;
      }
    }
    if (added == false) {
      conversations.add(Conversation(
          m.senderEmail,
          await findName(m.senderEmail),
          [SingleMessage(m.id, m.text, m.date, false)]));
      return conversations;
    }
  }
  return conversations;
}
