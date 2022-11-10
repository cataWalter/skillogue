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

void sortConversations(List<Conversation> c) {
  Comparator<Conversation> sortConversationsByDate =
      (a, b) => b.messages.last.date.compareTo(a.messages.last.date);
  c.sort(sortConversationsByDate);
}

