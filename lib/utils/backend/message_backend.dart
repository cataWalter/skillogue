import 'dart:collection';

import 'package:skillogue/utils/backend/profile_backend.dart';

import '../../entities/conversation.dart';
import '../../entities/message.dart';
import '../../entities/profile.dart';
import 'misc_backend.dart';

Future<List<Conversation>> getMessagesAll(String email) async {
  List<Conversation> newConversations = [];
  final List<dynamic> sentMessages =
      await supabase.from('message').select().eq('sender', email);
  final List<dynamic> receivedMessages =
      await supabase.from('message').select().eq('receiver', email);
  for (LinkedHashMap x in sentMessages) {
    newConversations =
        await addMessage(true, newConversations, parseMessage(x));
  }
  for (LinkedHashMap x in receivedMessages) {
    newConversations =
        await addMessage(false, newConversations, parseMessage(x));
  }
  sortConversations(newConversations);
  return newConversations;
}

Message parseMessage(LinkedHashMap x) {
  return Message(
    x.entries.elementAt(0).value,
    x.entries.elementAt(3).value,
    x.entries.elementAt(4).value,
    x.entries.elementAt(2).value,
    DateTime.parse(x.entries.elementAt(1).value),
    x.entries.elementAt(5).value,
  );
}

bool existsMessage(Message m, List<Conversation> conversations) {
  for (Conversation c in conversations) {
    for (SingleMessage x in c.messages) {
      if (m.id == x.id) {
        return true;
      }
    }
  }
  return false;
}

Future<List<Conversation>> addMessage(
    bool outgoing, List<Conversation> conversations, Message m) async {
  for (Conversation c in conversations) {
    for (SingleMessage x in c.messages) {
      if (m.id == x.id) {
        return conversations;
      } else if (m.date.isAtSameMomentAs(x.date) &&
          c.destEmail == m.receiverEmail) {
        x.id = m.id;
        return conversations;
      }
    }
  }
  bool added = false;
  if (outgoing) {
    for (Conversation c in conversations) {
      if (c.destEmail == m.receiverEmail) {
        added = true;
        c.messages.add(SingleMessage(m.id, m.text, m.date, true, false));
        c.messages = sortMessages(c.messages);
        return conversations;
      }
    }
    if (added == false) {
      Profile destProfile = await findProfileByEmail(m.receiverEmail);
      conversations.add(Conversation(
          m.receiverEmail,
          destProfile.name,
          destProfile.color,
          [SingleMessage(m.id, m.text, m.date, true, false)]));
      return conversations;
    }
  } else {
    for (Conversation c in conversations) {
      if (c.destEmail == m.senderEmail) {
        added = true;
        c.messages.add(SingleMessage(m.id, m.text, m.date, false, false));
        c.messages = sortMessages(c.messages);
        return conversations;
      }
    }
    if (added == false) {
      Profile destProfile = await findProfileByEmail(m.receiverEmail);
      conversations.add(Conversation(
          m.senderEmail,
          destProfile.name,
          destProfile.color,
          [SingleMessage(m.id, m.text, m.date, false, false)]));
      return conversations;
    }
  }
  sortConversations(conversations);
  return conversations;
}

parsePayload(payload, String email, List<Conversation> conversations) async {
  String eventType = payload.entries.elementAt(3).value;
  if (eventType == "INSERT") {
    conversations = await addMessage(
      payload.entries.elementAt(4).value.entries.elementAt(3).value == email,
      conversations,
      Message(
        payload.entries.elementAt(4).value.entries.elementAt(1).value,
        payload.entries.elementAt(4).value.entries.elementAt(3).value,
        payload.entries.elementAt(4).value.entries.elementAt(2).value,
        payload.entries.elementAt(4).value.entries.elementAt(4).value,
        DateTime.parse(
            payload.entries.elementAt(4).value.entries.elementAt(0).value),
        false,
      ),
    );
  }
}

Future<List<Conversation>> getNewMessages(
    String email, List<Conversation> newConversations) async {
  final List<dynamic> sentMessages =
      await supabase.from('message').select().eq('sender', email);
  final List<dynamic> receivedMessages =
      await supabase.from('message').select().eq('receiver', email);
  for (LinkedHashMap x in sentMessages) {
    newConversations =
        await addMessage(true, newConversations, parseMessage(x));
  }
  for (LinkedHashMap x in receivedMessages) {
    newConversations =
        await addMessage(false, newConversations, parseMessage(x));
  }
  sortConversations(newConversations);
  return newConversations;
}

Future<List<Conversation>> updateMessages(
    String email, List<Conversation> conversations) async {
  return await getNewMessages(email, conversations);
}
