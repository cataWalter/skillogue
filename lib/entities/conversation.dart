import 'package:skillogue/entities/message.dart';

class Conversation {
  String username;
  List<SingleMessage> messages;

  Conversation(this.username, this.messages);
}

class SingleMessage {
  String objectId;
  String text;
  DateTime date;
  bool outgoing;

  SingleMessage(this.objectId, this.text, this.date, this.outgoing);
}

Future<List<Conversation>> updateConversationsFromConvClass(
    String username) async {
  List<Conversation> c =
      await getConversationsFromMessages(username) as List<Conversation>;
  print("UPDATING CONVERSATIONS AT ${DateTime.now()}");
  sortConversations(c);
  return c;
}

void sortConversations(List<Conversation> c) {
  Comparator<Conversation> sortConversationsByDate =
      (a, b) => b.messages.last.date.compareTo(a.messages.last.date);
  c.sort(sortConversationsByDate);
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
