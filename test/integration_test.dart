import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:skillogue/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
  });

}
