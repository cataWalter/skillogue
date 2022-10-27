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
  bool read;

  SingleMessage(this.objectId, this.text, this.date, this.outgoing, this.read);
}
