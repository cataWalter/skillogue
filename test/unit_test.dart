import 'package:flutter_test/flutter_test.dart';
import 'package:skillogue/entities/conversation_entity.dart';

void main() {
  group("Conversation Entity", () {
    test("sortConversations", () {});
    test("sortMessages", () {
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      var y = sortMessages(messages);
      expect(
        true,
        y[0].date == d && y[1].date == d.add(Duration(days: 1)),
      );
    });
  });
}
