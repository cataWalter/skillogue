import '../../entities/conversation.dart';
import 'misc_backend.dart';
import '../constants.dart';

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

Future<List<Conversation>> getMessagesAll(String email) async {
  List<Conversation> newConversations = [];
  final List<dynamic> sentMessages =
      await supabase.from('message').select().eq('sender', email);
  final List<dynamic> receivedMessages =
      await supabase.from('message').select().eq('receiver', email);
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
      if (x.destEmail == newMessage[4]) {
        x.messages.add(
          SingleMessage(
            newMessage[0],
            newMessage[3],
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
          newMessage[4],
          await findName(newMessage[3]),
          [
            SingleMessage(
              newMessage[0],
              newMessage[3],
              DateTime.parse(newMessage[1]),
              true,
            )
          ],
        ),
      );
    }
  }  sortConversations(newConversations);
  return newConversations;
}
