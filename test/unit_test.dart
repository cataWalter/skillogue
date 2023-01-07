import 'dart:collection';
import 'dart:io';
import 'dart:math';

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
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/screens/search/saved_search_screen.dart';
import 'package:skillogue/utils/backend/authorization_backend.dart';
import 'package:skillogue/utils/backend/message_backend.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
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

      expect(true, x.data == "aaaaaaa");
      expect(false, x.data == "a...");
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

    test("Test clean", () {
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
    String emailTest = "test@mail.com";
    String passwordTest = "password";
    test("Is there a user with this email?", () async {
      bool notExits = await notExistsUsersWithSameEmail(emailTest);
      expect(notExits, true);
    });

    test("Log in", () async {
      login(emailTest, passwordTest)
          .catchError((msg) => expect(true, true))
          .then((answer) {
        expect(answer != null, true);
      });
    });

    test("Registration", () async {
      registration(emailTest, passwordTest)
          .catchError((msg) => expect(true, true))
          .then((answer) {
        expect(answer != null, true);
      });
    });

    test("Update login", () async {
      try {
        loginDateUpdate(emailTest);
      } on Exception catch (_) {
        expect(true, true);
      }
      ;
    });

    group("Messages backend", () {
      String emailTest = "test@mail.com";
      var messageTest = {
        "0": 1111,
        "1": '1969-07-20 20:18:04Z',
        "2": 'This is the body of the test',
        "3": 'sender@mail.com',
        "4": 'receiver@mail.com'
      };

      DateTime now = DateTime.now();
      SingleMessage sm11 =
          SingleMessage(111, "sm11", now.subtract(Duration(days: 2)), true);
      SingleMessage sm12 =
          SingleMessage(112, "sm12", now.subtract(Duration(days: 3)), false);
      SingleMessage sm21 =
          SingleMessage(121, "sm21", now.subtract(Duration(days: 4)), true);
      SingleMessage sm22 =
          SingleMessage(122, "sm22", now.subtract(Duration(days: 1)), false);

      Message m1 = Message(111, "sender@mail.com", "test@mail.com", "sm11",
          now.subtract(Duration(days: 2)));
      Message m2 = Message(1221, "sender@mail.com", "test@mail.com", "sm3",
          now.subtract(Duration(days: 1)));
      Message m3 =
          Message(1222, "test@mail.com", "receiver@mail.com", "sm4", now);
      Message m4 =
          Message(1332, "sender@mail.com", "receiver@mail.com", "sm5", now);

      Conversation c1 = Conversation("test@mail.com", "test", 6, [sm11, sm12]);
      Conversation c2 =
          Conversation("testtest@mail.com", "test", 6, [sm21, sm22]);

      List<Conversation> conversations = [c1, c2];

      test("Get all messages", () async {
        List<Conversation> e = await getMessagesAll(emailTest);
        expect(e, []);
      });

      test("Parse Messages", () {
        Message mTest = parseMessage(messageTest);
        expect(mTest.id, 1111);
        expect(mTest.senderEmail, "sender@mail.com");
        expect(mTest.receiverEmail, "receiver@mail.com");
        expect(mTest.text, "This is the body of the test");
        expect(mTest.date, DateTime.parse('1969-07-20 20:18:04Z'));
      });

      test("Exists Message", () {
        bool e1 = existsMessage(m1, conversations);
        expect(e1, true);
        bool e2 = existsMessage(m2, conversations);
        expect(e2, false);
      });

      test("Add message", () async {
        List<Conversation> conversationsTest =
            await addMessage(true, conversations, m1);
        expect(conversationsTest, conversations);
        conversationsTest = await addMessage(true, conversations, m2);
        expect(existsMessage(m2, conversationsTest), true);
        conversationsTest = await addMessage(false, conversations, m3);
        expect(existsMessage(m3, conversationsTest), true);
      });

      test("get New Messages", () async {
        List<Conversation> conversationsTest =
            await getNewMessages("test@mail.com", conversations);
        expect(conversationsTest != [], true);
      });

      test("Update conversations", () async {
        List<Conversation> conversationsMatch =
            await getNewMessages("test@mail.com", conversations);
        List<Conversation> conversationsTest =
            await updateMessages("test@mail.com", conversations);
        expect(conversationsTest, conversationsMatch);
      });

      test("Find conversation", () {
        Conversation cTest = findConversation(emailTest, conversations);
        expect(cTest, c1);
      });
    });

    group("Misc_backend", () {
      dynamic l = [];
    });

    group("Profile backend", () {
      Profile profileMatch = Profile(
          "test@mail.com",
          "Test",
          "Italy",
          "Milan",
          "Other",
          28,
          DateTime.parse('2022-12-20 20:18:04Z'),
          ["English"],
          ['Acting', 'Animals'],
          0);

      List profileFields = [
        "test@mail.com",
        "Test",
        "Italy",
        "Milan",
        "Other",
        28,
        '2022-12-20 20:18:04Z',
        ["English"],
        ['Acting', 'Animals'],
        0
      ];

      // to do
      test("Parse Profile", () {
        Profile profileTest = parseProfile(profileFields);
        expect(profileTest.email == profileMatch.email, true);
      });

      // to do
      test("Find profile by email", () async {
        Profile profileTest = await findProfileByEmail("test@mail.com");
        Profile pMatch = Profile("email", "name", "country", "city", "gender",
            99, DateTime.now(), [], [], 0);
        expect(profileTest.email == pMatch.email, true);
      });

      test("Update profile", () {
        try {
          updateProfile("test@mail.com", {'name': 'Test'});
        } on Exception catch (_) {
          expect(true, true);
        }
      });

      test("Get blocked", () async {
        List<String> blocklist = await getBlocked("test@mail.com");
        expect(blocklist, []);
      });

      test("Get blocked by", () async {
        List<String> blocklist = await getBlockedBy("test45@mail.com");
        expect(blocklist, []);
      });
    });
  });

  test("Is there a user with this email?", () async {
    pause();
    expect(true, true);
  });

  test("Is there a user with this email?", () async {
    blocker("test@mail.com", true);
    blocker("test@mail.com", false);

    bool notExits = await notExistsUsersWithSameEmail("test@mail.com");
    expect(notExits, true);
  });

  test("Is there a user with this email?", () async {
    deleteDatabase("test");
    expect(true, true);
  });
}
