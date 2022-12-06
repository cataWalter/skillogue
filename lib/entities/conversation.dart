class Conversation {
  String destEmail;
  String destName;

  List<SingleMessage> messages;

  Conversation(this.destEmail, this.destName, this.messages);
}

class SingleMessage {
  int id;
  String text;
  DateTime date;
  bool outgoing;

  SingleMessage(this.id, this.text, this.date, this.outgoing);
}

List<Conversation> sortConversations(List<Conversation> conversations) {
  Comparator<Conversation> sortConversationsByDate =
      (a, b) => a.messages.isNotEmpty && b.messages.isNotEmpty ? b.messages.last.date.compareTo(a.messages.last.date) : 1;
  conversations.sort(sortConversationsByDate);
  return conversations.toSet().toList();
}

List<SingleMessage> sortMessages(List<SingleMessage> messages) {
  Comparator<SingleMessage> sortConversationsByDate =
      (a, b) => a.date.compareTo(b.date);
  messages.sort(sortConversationsByDate);
  return messages;
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

int profileConversationIndex(
    List<Conversation> conversations, String lookupProfileEmail) {
  for (int i = 0; i < conversations.length; i++) {
    if (conversations[i].destEmail == lookupProfileEmail) return i;
  }
  return -1;
}
