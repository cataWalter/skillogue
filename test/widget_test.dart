import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_test/hive_test.dart';
import 'package:skillogue/entities/conversation_entity.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/screens/authorization/guided_registration_screen.dart';
import 'package:skillogue/screens/authorization/pre_login_screen.dart';
import 'package:skillogue/screens/authorization/sign_in_screen.dart';
import 'package:skillogue/screens/authorization/sign_up_screen.dart';
import 'package:skillogue/screens/authorization/splash_screen.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/screens/messages/message_screen.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/screens/profile/profile_overview.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';
import 'package:skillogue/screens/profile/profile_settings_screen.dart';
import 'package:skillogue/screens/search/profile_search_screen.dart';
import 'package:skillogue/screens/search/result_search_screen.dart';
import 'package:skillogue/screens/search/saved_search_screen.dart';
import 'package:skillogue/utils/constants.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  testWidgets('GuidedRegistration', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: GuidedRegistration("email", "pass")));
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
          Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        ),
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
        home: Scaffold(
          body: ProfileScreen(
            Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
            true,
          ),
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('ProfileSettings', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileSettings(
            Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
          ),
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('ProfileSearch', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SearchScreen(),
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('ResultsSearchScreen', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(const Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      List<Profile> searchResults = [
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ResultSearchScreen(searchResults),
        ),
      ));

      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('SavedSearchScreen', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      List<Profile> searchResults = [
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SavedSearchScreen(),
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('Home', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      List<Profile> searchResults = [
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Home([], 0),
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('Message', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      List<Profile> searchResults = [
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MessageScreen(),
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('SingleConversationScreen', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      Conversation x = Conversation("aaaa", "aaaa", 0, messages);
      List<Profile> searchResults = [
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleConversationScreen(x, true),
        ),
      ));
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('Home', (tester) async {
    await tester.runAsync(() async {
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      List<Profile> searchResults = [
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
      ];
      Conversation x = Conversation("aaaa", "aaaa", 0, messages);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Home([x], 2),
        ),
      ));
      /*await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("ciao")));
      await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("pop0")));*/

      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('pop0', (tester) async {
    await tester.runAsync(() async {
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
        SingleMessage(343, "hey", d, true),
      ];
      List<Profile> searchResults = [
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
      ];
      Conversation x = Conversation("aaaa", "aaaa", 0, messages);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileScreen(Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3), true),
        ),
      ));
      /*await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("ciao")));
      await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("pop0")));*/
      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });
}
