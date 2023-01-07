import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:skillogue/entities/conversation_entity.dart';
import 'package:skillogue/entities/message_entity.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/entities/profile_search_entity.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/utils/backend/authorization_backend.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/utils/data.dart';
import 'package:skillogue/utils/misc_functions.dart';

void main() {
  group("Conversation Entity", () {
    DateTime d = DateTime(1111, 10, 10, 10, 10, 10, 10, 10);
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    test("sortConversations", () {
      List<SingleMessage> messagesA = [
        SingleMessage(343, "hey1", now.subtract(Duration(days: 1)), true),
        SingleMessage(343, "hey1", now, true),
      ];
      List<SingleMessage> messagesB = [
        SingleMessage(344, "hey2", now.subtract(Duration(days: 2)), true),
        SingleMessage(344, "hey2", now.subtract(Duration(days: 3)), true),
      ];
      Conversation cA = Conversation('dest1@mail.com', 'dest1', 2, messagesA);
      Conversation cB = Conversation('dest2@mail.com', 'dest2', 3, messagesB);
      List<Conversation> conversations = [cA, cB];
      var y = sortConversations(conversations);
      expect(
        true,
        y[0] == cA && y[1] == cB,
      );
    });

    test("overflowreplacement", () {
      AutoSizeText x = getOverflowReplacement("aaaaaaa", true);
      AutoSizeText y = getOverflowReplacement("aaaaaaa", true);

      expect(
        true,
        x.data == "aaaaaaa"
      );
      expect(
          false,
          x.data == "a..."
      );
    });

    test("sortMessages", () {
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", now.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", now, true),
      ];
      var y = sortMessages(messages);
      expect(
        true,
        y[0].date == now && y[1].date == now.add(Duration(days: 1)),
      );
    });

    test("parseTime", () {
      String d_string = parseTime(d);
      expect('10:10', d_string);
    });

    test("parseDate", () {
      expect(parseDate(d), '10/10/1111');
      expect(parseDate(now), 'Today');
      expect(parseDate(yesterday), 'Yesterday');
    });

    test("parseSmallNumbers", () {
      expect(parseSmallNumbers(5), '05');
      expect(parseSmallNumbers(15), '15');
    });

    test("parseDateGroup", () {
      expect(parseDateGroup(d), '10/10/1111');
      expect(parseDateGroup(now), parseTime(now));
      expect(parseDateGroup(yesterday), 'Yesterday');
    });
  });

  group("Message entity", () {
    DateTime d = DateTime(1111, 10, 10, 10, 10, 10, 10, 10);
    test("Message", () {
      Message testMessage = Message(
          598, "sender@mail.com", "receiver@mail.com", "test message", d);
      expect(testMessage.text, "test message");
      expect(testMessage.id, 598);
      expect(testMessage.senderEmail, "sender@mail.com");
      expect(testMessage.receiverEmail, "receiver@mail.com");
      expect(testMessage.date, d);
    });
  });

  group("Profile entity and profile search entity", () {
    List<String> skillsTest = ['Hiking', 'Nature', 'Climbing', 'Camping'];
    List<String> languagesTest = ["English", "Italian", "Spanish"];

    test("Evaluate personality", () {
      String personality = evaluatePersonality(skillsTest);
      expect(personality, "Executive");
    });

    test("Suggest Skills", () {
      List<String> suggested_skills =
      suggestFeature(skillsTest, 3, skills, skillSimilarity);
      expect(suggested_skills, ["Gardening", "Kayaking", "Traveling"]);
    });
    test("Suggest Languages", () {
      List<String> suggested_languages =
      suggestFeature(languagesTest, 3, languages, languageSimilarity);
      expect(suggested_languages, ["French", "Portuguese", "Sicilian"]);
    });

    test("Find Max", () {
      for (var x in countrySimilarity) {
        var y = findMax(10, x);
        expect(y.length >= 10, true);
      }
    });

    test("Test clean", (){
      ProfileSearch test1 = ProfileSearch();
      test1.clean();
      expect(test1.skills, []);
      expect(test1.languages, []);
      expect(test1.countries, []);
      expect(test1.genders, []);
      expect(test1.city, "");
    });
  });
  group("Colors", () {
    test("Is this color dark?", () {
      expect(true, isDarkColor(Colors.black));
    });

    test("Getting a random dark color", () {
      Color randomDarkColor = getRandomDarkColor();
      bool isDark = isDarkColor(randomDarkColor);
      expect(true, isDark);
    });
  });

  group("Localization", () {
    test("Translation", () {
      // to do
    });
  });

  group("Misc Functions", () {
    test("Get initials of the fullname", () {
      String t1 = "Test1";
      String t2 = "Te";
      String i1 = initials(t1);
      String i2 = initials(t2);
      expect(i1, "TES");
      expect(i2, "");
    });

    test("String to date time", () {
      DateTime d = DateTime.parse('1969-07-20 20:18:04Z');
      expect(stringToDatetime('1969-07-20 20:18:04Z'), d);
    });

    /* to do
    test("Add vertical space", () {
      int h = 20;
      SizedBox sTest = addVerticalSpace(h);
      SizedBox s = SizedBox(
        height: h.toDouble(),
      );
      expect(
        sTest == s,
        true
      );
    });
    */

    /* to do
    test("Add horizontal space", () {
      int w = 20;
      expect(
          addHorizontalSpace(w),
          SizedBox(
            width: w.toDouble(),
          )
      );
    });
    */

    test("Get element's index", () {
      List<String> lTest = ["e1", "e2", "e3"];
      String eTest = "e2";
      expect(getElementIndex(eTest, lTest), 1);
      expect(getElementIndex("eT", lTest), -1);
    });
  });

  group("Authorization Backend", () {
    test("Is there a user with this email?", () async {
      String emailTest = "test@mail.com";
      bool notExits = await notExistsUsersWithSameEmail(emailTest);
      expect(notExits, true);
    });
  });
}
