
import '../../entities/conversation.dart';
import '../../entities/message.dart';
import '../backend.dart';
import '../constants.dart';

Future<List<Conversation>> getMessagesNew(
    String email, List<Conversation> newConversations) async {
  final List<dynamic> sentMessages = await supabase
      .from('message')
      .select()
      .eq('sender', email)
      .match({"downloaded_by_receiver": false});

  final List<dynamic> receivedMessages = await supabase
      .from('message')
      .select()
      .eq('receiver', email)
      .match({"downloaded_by_sender": false});
  if (sentMessages.length + receivedMessages.length == 0) {
    return newConversations;
  }
  return updateConversations(newConversations, sentMessages, receivedMessages);
}

Future<List<Conversation>> getMessagesAll(String email) async {
  List<Conversation> newConversations = [];
  final List<dynamic> sentMessages =
  await supabase.from('message').select().eq('sender', email);
  final List<dynamic> receivedMessages =
  await supabase.from('message').select().eq('receiver', email);
  return updateConversations(newConversations, sentMessages, receivedMessages);
}

updateConversations(newConversations, sentMessages, receivedMessages) async {
  for (Message m in sentMessages) {
    setReceivedSender(m.id);
  }
  for (Message m in receivedMessages) {
    setReceivedReceiver(m.id);
  }
  bool added;
  for (var newMessageMap in sentMessages) {
    var newMessage = parseLinkedMap(newMessageMap);
    added = false;
    for (Conversation x in newConversations) {
      if (x.destEmail == newMessage[3]) {
        x.messages.add(
          SingleMessage(
            newMessage[0],
            newMessage[4],
            DateTime.parse(newMessage[1]),
            true,
          ),
        );
        added = true;
        break;
      }
    }
    if (added == false) {
      newConversations.add(
        Conversation(
          newMessage[3],
          await findName(newMessage[3]),
          [
            SingleMessage(
              newMessage[0],
              newMessage[4],
              DateTime.parse(newMessage[1]),
              true,
            )
          ],
        ),
      );
    }
  }
  for (var newMessageMap in receivedMessages) {
    var newMessage = parseLinkedMap(newMessageMap);
    added = false;
    for (Conversation x in newConversations) {
      if (x.destEmail == newMessage[2]) {
        x.messages.add(
          SingleMessage(
            newMessage[0],
            newMessage[4],
            DateTime.parse(newMessage[1]),
            false,
          ),
        );
        added = true;
        break;
      }
    }
    if (added == false) {
      newConversations.add(
        Conversation(
          newMessage[2],
          await findName(newMessage[2]),
          [
            SingleMessage(
              newMessage[0],
              newMessage[4],
              DateTime.parse(newMessage[1]),
              false,
            )
          ],
        ),
      );
    }
  }
  sortConversations(newConversations);
  return newConversations;
}

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
  });
}

void setReceivedReceiver(id) async {
  await supabase
      .from('message')
      .update({'downloaded_by_receiver': true}).match({'id': id});
}

void setReceivedSender(id) async {
  await supabase
      .from('message')
      .update({'downloaded_by_sender': true}).match({'id': id});
}
