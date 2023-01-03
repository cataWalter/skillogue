class Conversation {
  String destEmail;
  String destName;
  int destPoints;
  List<SingleMessage> messages;

  Conversation(this.destEmail, this.destName, this.destPoints, this.messages);
}

class SingleMessage {
  int id;
  String text;
  DateTime date;
  bool outgoing;

  SingleMessage(this.id, this.text, this.date, this.outgoing);
}

Comparator<Conversation> sortConversationsByDate = (a, b) =>
    a.messages.isNotEmpty && b.messages.isNotEmpty
        ? b.messages.last.date.compareTo(a.messages.last.date)
        : 1;

List<Conversation> sortConversations(List<Conversation> conversations) {
  conversations.sort(sortConversationsByDate);
  return conversations.toSet().toList();
}

Comparator<SingleMessage> sortMessagesByDate =
    (a, b) => a.date.compareTo(b.date);

List<SingleMessage> sortMessages(List<SingleMessage> messages) {
  messages.sort(sortMessagesByDate);
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
