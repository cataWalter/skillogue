class Message {
  int id;
  String senderEmail;
  String receiverEmail;
  String text;
  DateTime date;
  bool read;

  Message(this.id, this.senderEmail, this.receiverEmail, this.text, this.date, this.read);
}
