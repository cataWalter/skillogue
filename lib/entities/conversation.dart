class Conversation {
  String username;
  List<SingleMessage> messages;

  Conversation(this.username, this.messages);
}

class SingleMessage {
  String text;
  DateTime date;
  bool outgoing;
  bool read;

  SingleMessage(this.text, this.date, this.outgoing, this.read);
}
