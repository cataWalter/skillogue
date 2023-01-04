import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_test/hive_test.dart';
import 'package:skillogue/entities/conversation_entity.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/screens/authorization/guided_registration_screen.dart';
import 'package:skillogue/screens/authorization/pre_login_screen.dart';
import 'package:skillogue/screens/authorization/sign_in_screen.dart';
import 'package:skillogue/screens/authorization/sign_up_screen.dart';
import 'package:skillogue/screens/authorization/splash_screen.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/screens/profile/profile_overview.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/utils/constants.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  testWidgets('GuidedRegistration', (tester) async {
    await tester
        .pumpWidget(MaterialApp(home: GuidedRegistration("email", "pass")));
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets('PreLogin', (tester) async {
    await tester.pumpWidget(MaterialApp(home: PreLogin()));
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets('Login', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets('Registration', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Registration()));
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets('Splash', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);

      GoogleFonts.config.allowRuntimeFetching = false;
      await tester.pumpWidget(MaterialApp(home: SplashScreen()));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('MessageScreen', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: MessageScreen()));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('ConversationScreen', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      GoogleFonts.config.allowRuntimeFetching = false;
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: SingleConversationScreen(
              Conversation("a", "a", 0, messages), true),
        ),
      );
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('ProfileOverview', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      await tester.pumpWidget(MaterialApp(
        home: ProfileOverview(
            Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3)),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('ProfileScreen', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      await tester.pumpWidget(MaterialApp(
        home: ProfileScreen(
          Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
          true,
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });
}
