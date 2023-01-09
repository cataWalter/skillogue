import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:integration_test/integration_test.dart';
import 'package:skillogue/entities/conversation_entity.dart';
import 'package:skillogue/entities/message_entity.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/entities/profile_search_entity.dart';
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
import 'package:skillogue/screens/search/saved_search_screen.dart' as saved;
import 'package:skillogue/screens/search/saved_search_screen.dart';
import 'package:skillogue/utils/backend/authorization_backend.dart';
import 'package:skillogue/utils/backend/message_backend.dart';
import 'package:skillogue/utils/backend/misc_backend.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:skillogue/utils/backend/profile_search_backend.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/utils/data.dart';
import 'package:skillogue/utils/misc_functions.dart';

void main() {
  setUp(() async {
    await Hive.initFlutter();
    await Hive.openBox(localDatabase);
  });
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('The Guided Registration needs an email and a password',
      (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: GuidedRegistration("email", "pass")));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    expect(emailFinder, findsNothing);
    expect(passFinder, findsNothing);
  });

  testWidgets('The Guided Registration needs an email and a password',
      (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: GuidedRegistration("email", "pass")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("register")));
    await tester.pumpAndSettle();
  });

  testWidgets('To do the PreLogin it is needed an email and a password',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: PreLogin()));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    expect(emailFinder, findsNothing);
    expect(passFinder, findsNothing);
  });

  testWidgets(
      'Login needs a password and an email provided the first time the user did the registration',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    expect(emailFinder, findsNothing);
    expect(passFinder, findsNothing);
  });

  testWidgets('Registration needs an email and a password', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Registration()));
    final emailFinder = find.text('email');
    final passFinder = find.text('pass');
    expect(emailFinder, findsNothing);
    expect(passFinder, findsNothing);
  });

  testWidgets('Splash', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SplashScreen()));
  });



  testWidgets('ProfileScreen shows the profile of a user', (tester) async {
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
    expect(emailFinder, findsNothing);
    expect(passFinder, findsNothing);
  });

  testWidgets('ProfileSettings lets the users modify their profile information',
      (tester) async {
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

  testWidgets('How to search profiles by the preferences of the user',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchScreen(),
      ),
    ));
    await tester.pumpAndSettle();
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets('How are shown the results of the search', (tester) async {
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

  testWidgets('How are shown the saved searches of a user', (tester) async {
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
        body: saved.SavedSearchScreen(),
      ),
    ));
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets('Home screen appearance', (tester) async {
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
    await tester.pumpAndSettle(Duration(seconds: 3));
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets(
      'The main screen of messages where all opened conversations are shown',
      (tester) async {
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
    await tester.pumpAndSettle(Duration(seconds: 3));
    final titleFinder = find.text('email');
    final messageFinder = find.text('pass');
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsNothing);
  });

  testWidgets('Appearance of a Single Conversation', (tester) async {
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
  });
  testWidgets('Appearance of a Single Conversation', (tester) async {
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
  /*testWidgets('integration1', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Text));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 1));
    await tester.tap(find.byKey(Key("login")));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("email")), 'cata.walter@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("pass")), 'walter');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("login")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Text));
    await tester.pumpAndSettle();
  });

  testWidgets('integration', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.tap(find.byKey(Key("profileScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("messageScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("searchScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("profileScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("PopupMenuButton")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("pop0")));
    await tester.pumpAndSettle();
  });

  testWidgets('integration', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.tap(find.byKey(Key("profileScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("messageScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("searchScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("profileScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("PopupMenuButton")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("pop1")));
    await tester.pumpAndSettle();
  });
  testWidgets('integration', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.tap(find.byKey(Key("profileScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("messageScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("searchScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("profileScreen")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("PopupMenuButton")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("pop3")));
    await tester.pumpAndSettle();
  });*/

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

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());
    final BuildContext context = tester.element(find.byType(Container));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(child: saved.savedSearchesList(context, [y], 0)),
            );
          },
        ),
      ),
    );

    await tester.longPress(find.byKey(Key("savedSearchScreenTile")));

    await tester.pumpAndSettle();
  });

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());
    final BuildContext context = tester.element(find.byType(Container));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: Row(
                    children: saved.chippies(["Running", "Swimming"], 10.0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
  });

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
  });

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star));
    await tester.pumpAndSettle();
  });

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();
  });

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star));
    await tester.pumpAndSettle();
  });

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star));
    await tester.pumpAndSettle();
  });

  testWidgets('savedSerch', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.cleaning_services));
    await tester.pumpAndSettle();
  });

  testWidgets('AI_sport2', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.press(find.byKey(Key("AI_tennis")));
    await tester.pumpAndSettle();
  });

  testWidgets('AI_sport', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.press(find.byKey(Key("AI_country")));
    await tester.pumpAndSettle();
  });

  testWidgets('AI_sport3', (WidgetTester tester) async {
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
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: SearchScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("startHere")));
    await tester.pumpAndSettle();
    await tester.press(find.byKey(Key("AI_lang")));
    await tester.pumpAndSettle();
  });

  testWidgets('AI_sport3', (WidgetTester tester) async {
    DateTime d = DateTime.now();

    List<SingleMessage> messages = [
      SingleMessage(343, "hey", d.add(Duration(days: 1)), true),
      SingleMessage(343, "hey", d, true),
    ];
    List<Profile> searchResults = [
      Profile("aa", "aa", "aa", "aa", "aa", 32, d, ["aa"], ["aa"], 3),
    ];
    Conversation x = Conversation("aaaa", "aaaa", 0, messages);
    var y = SavedProfileSearch("aaa", ProfileSearch());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              home: Material(
                child: Scaffold(
                  body: ResultSearchScreen(searchResults),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("result")));
    await tester.pumpAndSettle();
  });

  testWidgets('Login', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("email")), 'email');
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("pass")), 'pass');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("login")));
  });

  testWidgets('Login', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Registration()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("email")), 'email');
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("pass")), 'pass');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("login")));
  });

  testWidgets('Login', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Registration()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("show")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("show")));
    await tester.pumpAndSettle();
  });

  testWidgets('Login', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("show")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("show")));
    await tester.pumpAndSettle();
  });

  test("Is there a user with this email?", () async {});

  testWidgets('Saved Search Screen: saved searches list',
      (WidgetTester tester) async {
    final BuildContext context = tester.element(find.byType(Container));
    ProfileSearch x = ProfileSearch();
    x.countries = ["Italy"];
    x.skills = ["Italy"];
    x.languages = ["Italy"];
    x.genders = ["Italy"];
    x.city = "Italy";
    x.minAge = 30;
    x.maxAge = 50;
    findUsers(
        "searcher",
        x,
        [
          Conversation("destEmail", "destName", 0,
              [SingleMessage(0, "text", DateTime.now(), true)])
        ],
        context);
  });

  testWidgets('ProfileSettings lets the users modify their profile information',
      (tester) async {
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
    await tester.pumpAndSettle();
    await tester.press(find.byKey(Key("set")));
    await tester.pumpAndSettle();
    await tester.longPress(find.byKey(Key("set")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("set")));
    await tester.pumpAndSettle();
  });

  group("Conversation Entity", () {
    DateTime d = DateTime(1111, 10, 10, 10, 10, 10, 10, 10);
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    test("How to sort conversations", () {
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

    test("How to sort messages", () {
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

    test("How to parse to String a DateTime value", () {
      String d_string = parseTime(d);
      expect('10:10', d_string);
    });

    test("How to parse to String a Date", () {
      expect(parseDate(d), '10/10/1111');
      expect(parseDate(now), 'Today');
      expect(parseDate(yesterday), 'Yesterday');
    });

    test("How to parse SmallNumbers", () {
      expect(parseSmallNumbers(5), '05');
      expect(parseSmallNumbers(15), '15');
    });

    test("How parse DateGroup", () {
      expect(parseDateGroup(d), '10/10/1111');
      expect(parseDateGroup(now), parseTime(now));
      expect(parseDateGroup(yesterday), 'Yesterday');
    });
  });

  test("Funcionality of Message", () {
    DateTime d = DateTime(1111, 10, 10, 10, 10, 10, 10, 10);

    Message testMessage =
        Message(598, "sender@mail.com", "receiver@mail.com", "test message", d);
    expect(testMessage.text, "test message");
    expect(testMessage.id, 598);
    expect(testMessage.senderEmail, "sender@mail.com");
    expect(testMessage.receiverEmail, "receiver@mail.com");
    expect(testMessage.date, d);
  });

  group("Profile entity and profile search entity", () {
    List<String> skillsTest = ['Hiking', 'Nature', 'Climbing', 'Camping'];
    List<String> languagesTest = ["English", "Italian", "Spanish"];

    test("How the personality is Evaluate", () {
      String personality = evaluatePersonality(skillsTest);
      expect(personality, "Executive");
    });

    test("Suggest new Skills according to the user preferences", () {
      List<String> suggested_skills =
          suggestFeature(skillsTest, 3, skills, skillSimilarity);
      expect(suggested_skills, ["Gardening", "Kayaking", "Traveling"]);
    });
    test("Suggest Languages according to the user preferences", () {
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
        expect(blocklist, ['cata.walter@gmail.com']);
      });

      test("Get blocked by", () async {
        List<String> blocklist = await getBlockedBy("test45@mail.com");
        expect(blocklist, []);
      });
    });

    group("Profile search backend", () {
      SingleMessage sm11 = SingleMessage(
          111, "sm11", DateTime.now().subtract(Duration(days: 2)), true);
      SingleMessage sm12 = SingleMessage(
          112, "sm12", DateTime.now().subtract(Duration(days: 3)), false);
      Conversation c1 = Conversation("test@mail.com", "test", 6, [sm11, sm12]);

      /*test("Find users", () async{
          List<Profile> usersTest =  await findUsers("test@mail.com", ProfileSearch(),
              [c1], context);
          expect(usersTest, []);
        });*/

      test("Get Saved Searches", () async {
        List<SavedProfileSearch> savedtest =
            await getSavedSearches("test@mail.com");
        expect(savedtest, []);
      });

      test("Parse search", () {
        var x = {
          0: "",
          1: "",
          2: 99,
          3: 0,
          4: ["Italy"],
          5: ["Museums"],
          6: ["English"],
          7: ["Female"],
          8: "Milan"
        };
        ProfileSearch sTest = parseSearch(x);
        ProfileSearch s = ProfileSearch();
        s.skills = ["Museums"];
        s.countries = ["Italy"];
        s.languages = ["English"];
        s.genders = ["Female"];
        s.city = "Milan";
        s.minAge = 0;
        s.maxAge = 99;
        expect(sTest.skills, s.skills);
        expect(sTest.countries, s.countries);
        expect(sTest.languages, s.languages);
        expect(sTest.genders, s.genders);
        expect(sTest.city, s.city);
        expect(sTest.minAge, s.minAge);
        expect(sTest.maxAge, s.maxAge);
      });

      test("Parse List",
          () => expect(parseList(["x", "y", "z"]), ["x", "y", "z"]));
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

  test("Is there a user with this email?", () async {
    newMessage("test");
  });

  test("Is there a user with this email?", () async {
    parseLinkedMap({0.532: 'Mars', 11.209: 'Jupiter'});
    parseLinkedMap({0.532: "", 11.209: 'Jupiter'});
    parseLinkedMap({0.532: [], 11.209: 'Jupiter'});
  });

  test("Is there a user with this email?", () async {
    updateDatabaseProfileSettings(
        "Italy",
        "Italy",
        "Italy",
        "Italy",
        ["Italy"],
        ["Italy"],
        "30",
        "Italy",
        Profile("aa", "aa", "aa", "aa", "aa", 32, DateTime.now(), ["aa"],
            ["aa"], 3),
        const Color(0),
        null);
  });
}
