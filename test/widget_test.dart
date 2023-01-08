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
import 'package:skillogue/utils/misc_functions.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  testWidgets('The Guided Registration needs an email and a password', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: GuidedRegistration("email", "pass")));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    //expect(emailFinder, findsNothing);
    expect(emailFinder, findsOneWidget);
    //expect(passFinder, findsNothing);
    expect(passFinder, findsOneWidget);
  });

  testWidgets('To do the PreLogin it is needed an email and a password', (tester) async {
    await tester.pumpWidget(MaterialApp(home: PreLogin()));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    //expect(emailFinder, findsNothing);
    expect(emailFinder, findsOneWidget);
    //expect(passFinder, findsNothing);
    expect(passFinder, findsOneWidget);
  });

  testWidgets(
      'Login needs a password and an email provided the first time the user did the registration',
          (tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    //expect(emailFinder, findsNothing);
    expect(emailFinder, findsOneWidget);
    //expect(passFinder, findsNothing);
    expect(passFinder, findsOneWidget);
  });

  testWidgets('Registration needs an email and a password', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Registration()));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    //expect(emailFinder, findsNothing);
    expect(emailFinder, findsOneWidget);
    //expect(passFinder, findsNothing);
    expect(passFinder, findsOneWidget);
  });

  testWidgets('Splash', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);

      GoogleFonts.config.allowRuntimeFetching = false;
      await tester.pumpWidget(MaterialApp(home: SplashScreen()));
      final emailFinder = find.text('email');
      final passFinder = find.text('pass');
      //expect(emailFinder, findsNothing);
      expect(emailFinder, findsOneWidget);
      //expect(passFinder, findsNothing);
      expect(passFinder, findsOneWidget);
    });
  });

  testWidgets('ProfileOverview has an icon that can be clicked', (tester) async {
    await tester.runAsync(() async {
      await Hive.initFlutter();
      await Hive.openBox(localDatabase);
      DateTime d = DateTime.now();
      List<SingleMessage> messages = [
        SingleMessage(343, "m1", d.add(Duration(days: 1)), true),
        SingleMessage(344, "m2", d, true),
      ];
      await tester.pumpWidget(MaterialApp(
        home: ProfileOverview(
          Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
        ),
      ));
      final emailFinder = find.text('email');
      final passFinder = find.text('pass');
      //expect(emailFinder, findsNothing);
      expect(emailFinder, findsOneWidget);
      //expect(passFinder, findsNothing);
      expect(passFinder, findsOneWidget);
    });
  });

  testWidgets('ProfileScreen shows the profile of a user', (tester) async {
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
      final emailFinder = find.text('email');
      final passFinder = find.text('pass');
      //expect(emailFinder, findsNothing);
      expect(emailFinder, findsOneWidget);
      //expect(passFinder, findsNothing);
      expect(passFinder, findsOneWidget);
    });
  });

  testWidgets('ProfileSettings lets the users modify their profile information', (tester) async {
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

  testWidgets('How to search profiles by the preferences of the user', (tester) async {
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

  testWidgets('How are shown the results of the search', (tester) async {
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

  testWidgets('How are shown the saved searches of a user', (tester) async {
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

  testWidgets('Home screen appearance', (tester) async {
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

  testWidgets('The main screen of messages where all opened conversations are shown', (tester) async {
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

  testWidgets('Appearance of a Single Conversation', (tester) async {
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
          body: ProfileScreen(
              Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
              true),
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

      await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("searchScreen")));
      await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("startHere")));
      await tester.pump(Duration(seconds: 2));
      await tester.press(find.byKey(Key("saved")));
      await tester.pump(Duration(seconds: 2));
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

      await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("profileScreen")));
      await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byKey(Key("PopupMenuButton")));
      await tester.pumpAndSettle();

      await tester.press(find.byKey(Key("pop2")));
      await tester.pumpAndSettle();

      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('showDialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));

    newSuggestion(context, TextEditingController());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("suggest")));
    await tester.pumpAndSettle();
  });

  testWidgets('showDialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));

    getBlurDialog(context, "aaa", "aaa");
    await tester.pumpAndSettle();
  });

  testWidgets('showDialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));

    getBlurDialogImage(context, "aaa", 'assets/images/logo.png', "exit");
    await tester.pumpAndSettle();
  });

  testWidgets('tabletCard', (tester) async {
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
          body: MessageScreen(),
        ),
      ));

      await tester.pump(Duration(seconds: 10));

      final titleFinder = find.text('email');
      final messageFinder = find.text('pass');
      expect(titleFinder, findsNothing);
      expect(messageFinder, findsNothing);
    });
  });

  testWidgets('showDialog', (WidgetTester tester) async {
    DateTime d = DateTime.now();

    final BuildContext context = tester.element(find.byType(Container));
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
    await tester
        .pumpWidget(MaterialApp(home: Material(child: tabletChat(x, true))));
    await tester.pumpAndSettle();
    await tester
        .pumpWidget(MaterialApp(home: Material(child: tabletChat(x, false))));
    await tester.pumpAndSettle();
  });

  testWidgets('showDialog', (WidgetTester tester) async {
    DateTime d = DateTime.now();

    final BuildContext context = tester.element(find.byType(Container));
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
    await tester.pumpWidget(
        MaterialApp(home: Material(child: mobileChatCard(context, x))));
    await tester.pumpAndSettle();
  });

  testWidgets('showDialog', (WidgetTester tester) async {
    DateTime d = DateTime.now();

    final BuildContext context = tester.element(find.byType(Container));
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
        home: Material(
            child: getSingleMessageWidget(
      SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
    ))));
    await tester.pumpAndSettle();
    await tester.pumpWidget(MaterialApp(
        home: Material(
            child: getSingleMessageWidget(
      SingleMessage(343, "hey", d.add(Duration(days: 1)), false),
    ))));
    await tester.pumpAndSettle();
  });

  testWidgets('showDialog', (WidgetTester tester) async {
    DateTime d = DateTime.now();

    final BuildContext context = tester.element(find.byType(Container));
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
    /*await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: save
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(MaterialApp(
        home: Material(
            child: getSingleMessageWidget(
      SingleMessage(343, "hey", d.add(Duration(days: 1)), false),
    ))));
    await tester.pumpAndSettle();*/
  });

  /*testWidgets('Saved Search Screen: saved searches list',
      (WidgetTester tester) async {
    final BuildContext context = tester.element(find.byType(Container));
    await tester.pumpWidget(
        MaterialApp(home: Material(child: savedSearchesList(context, 1))));
    //print((savedSearchesList(context, 1).decoration as BoxDecoration).color);
  });*/
}
